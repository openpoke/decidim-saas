# frozen_string_literal: true

require "csv"

namespace :decidim_saas do
  namespace :import do
    desc "Import votes from CSV. Usage: rake 'decidim_saas:import:votes[users.csv,42,3]'"
    task :votes, %i[csv_file proposal_id weight] => :environment do |_task, args|
      csv_path = args[:csv_file]
      proposal_id = args[:proposal_id]&.to_i
      weight = args[:weight]&.to_i

      if csv_path.blank? || proposal_id.blank? || weight.blank?
        abort "Usage: rake 'decidim_saas:import:votes[users.csv,PROPOSAL_ID,WEIGHT]'"
      end

      unless File.exist?(csv_path)
        abort "Error: CSV file '#{csv_path}' not found."
      end

      import_votes(csv_path, proposal_id, weight)
    end
  end

  def import_votes(csv_path, proposal_id, weight)
    proposal = Decidim::Proposals::Proposal.find_by(id: proposal_id)
    abort "Error: Proposal ##{proposal_id} not found." unless proposal

    organization = proposal.organization
    csv = CSV.parse(File.read(csv_path), headers: true)

    imported = 0
    skipped = 0
    could_not_import = 0

    puts "Importing votes for proposal ##{proposal_id} (weight: #{weight})"
    puts "CSV file: #{csv_path} (#{csv.length} rows)"

    csv.each do |row|
      email = row["email"]&.strip&.downcase
      name = row["name"]&.strip

      if email.blank? || name.blank?
        puts "Skipping row with missing email or name: #{row.to_h}"
        could_not_import += 1
        next
      end

      user = find_or_create_user(email, name, organization)
      unless user
        could_not_import += 1
        next
      end

      existing_vote = Decidim::Proposals::ProposalVote.find_by(proposal: proposal, author: user)
      if existing_vote
        skipped += 1
        puts "Skipping existing vote for #{email} on proposal ##{proposal_id}"
        next
      end

      vote = Decidim::Proposals::ProposalVote.new(
        proposal: proposal,
        author: user
      )

      if vote.save
        vote.weight = weight
        imported += 1
      else
        puts "Could not import vote for #{email} on proposal ##{proposal_id}: #{vote.errors.full_messages.join(', ')}"
        could_not_import += 1
      end

    end

    puts "Proposal ##{proposal_id}: #{imported} votes imported, #{skipped} already existed, #{could_not_import} could not import"
  end

  def find_or_create_user(email, name, organization)
    existing = Decidim::User.find_by(email: email, organization: organization)

    if existing
      puts "Found existing user: #{email} (#{name}, ID: #{existing.id})"
      return existing
    end

    nickname = Decidim::UserBaseEntity.nicknamize(name, organization.id)
    password = SecureRandom.hex(8)

    user = Decidim::User.new(
      email: email,
      name: name,
      nickname: nickname,
      password: password,
      organization: organization,
      tos_agreement: true,
      accepted_tos_version: organization.tos_version,
      extended_data: {}
    )
    user.confirm
    user.skip_invitation = true
    user.invite!

    if user.save
      puts "Created user: #{email} (#{name}, ID: #{user.id})"
      user
    else
      puts "Could not create user #{email}: #{user.errors.full_messages.join(', ')}"
      nil
    end
  end
end
