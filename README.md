# Decidim SaaS PokeCode

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for decidim_saas, based on [Decidim](https://github.com/decidim/decidim).

## About

This is a [PokeCode](https://www.pokecode.net) private installations.

Features a customized Gemfile that can load/disable certain specific modules, depending on the ENV variables is set or not.

### Automatic Translations

The Azure AI translator API is integrated (via microsof ttranslator), ENV vars:

- `TRANSLATOR_API_KEY` the API KEY needed to make it work
- `TRANSLATOR_REGION` the region associated with your Azure subscription (defaults to `westeurope`)
- `TRANSLATOR_ENDPOINT` the endpoint for the Azure Translator API (defaults to `https://api.cognitive.microsofttranslator.com`)

Also a rake task is create to allow automatic translation of content already created:

Use with source,target language:

```bash
bin/rails saas:translate_all[ca,es]
```

### Current extra modules:

1. `WITH_EXTRA_USER_FIELDS=1` Loads the [decidim-extra_user_fields](https://github.com/openpoke/decidim-module-extra_user_fields) module-
2. `WITH_SOM_MOBILITAT=1` Loads the internal [decidim-som_mobilitat](decidim-som_mobilitat/) module.
3. `WITH_CLEAN_CLOTHES=1` Loads the internal [decidim-clean_clothes](decidim-clean_clothes/) module (note that this module is not compatible with decidim-extra_user_fields, load one or the other, not both).

### Implementation

The `Gemfile` is created with `require: false` for each of those modules. Loading is done therefore in the [config/application.rb](config/application.rb) file manually.

To update the Gemfile.lock is necessary to set up the variables for the modules on the operations `decidim:upgrade`, `db:migrate` etc.

You can ensure all ENVs are on by running the helper [bin/upgrade](bin/upgrade):

```bash
bin/upgrade
```

#### Creating a new Saas Module:

1. Create the module under `saas-new_module` directory.
2. Add it to the [Gemfile](Gemfile) with the parameter `require: false`.
3. Add an entry with the corresponding associated ENV var (`WITH_NEW_MODULE`) into the files:
  - [config/application.rb](config/application.rb)
  - [spec/saas_modules_spec.rb](spec/saas_modules_spec.rb)
  - [.github/workflows/test.yml](.github/workflows/test.yml)
  - [Dockerfile](Dockerfile)

PokeCode 2025
