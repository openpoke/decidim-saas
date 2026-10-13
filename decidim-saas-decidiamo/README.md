# Saas::CleanClothes

Custom authorizations for Decidiamo.

## Environment variables

Set the onboarding survey id when you want newly accepted users to be redirected to a required questionnaire before continuing:

```bash
export ONBOARDING_SURVEY_ID=123
```

- `ONBOARDING_SURVEY_ID` is the Decidim survey id used by the onboarding completion check.
- If it is not set, the onboarding survey redirect is skipped.
- The survey is enforced after the user accepts the terms of service, and they are redirected until they answer it.

Run with:

```ruby
WITH_DECIDIAMO=1 bin/rails s
```

# Running specs:

From the main folder (one below this)

```
WITH_DECIDIAMO=1 bundle exec rspec decidim-saas-decidiamo
```