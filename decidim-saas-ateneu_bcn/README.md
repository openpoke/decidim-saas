# Saas::AteneuBcn

Custom authorizations for Ateneu Barcelonès.

## SinergiaCRM login

The module includes the `sinergia_crm` OmniAuth strategy for SinergiaCRM's
Portal OAuth2 authorization-code flow. Configure the OAuth client in the CRM,
then set these environment variables for the Decidim application:

| Variable | Purpose |
| --- | --- |
| `SINERGIA_CRM_SITE` | Base URL of the SinergiaCRM instance |
| `SINERGIA_CRM_CLIENT_ID` | OAuth client ID |
| `SINERGIA_CRM_CLIENT_SECRET` | OAuth client secret, when using a confidential client |
| `SINERGIA_CRM_AUTHORIZE_URL` | Authorization endpoint path (default: `/oauth/authorize`) |
| `SINERGIA_CRM_TOKEN_URL` | Token endpoint path (default: `/oauth/token`) |
| `SINERGIA_CRM_USER_INFO_URL` | Authenticated endpoint returning the portal user's JSON profile (default: `/oauth/userinfo`) |
| `SINERGIA_CRM_UID_FIELD` | Profile field used as the stable user ID (default: `id`) |
| `SINERGIA_CRM_NAME_FIELD` | Profile field for the user's name (default: `name`) |
| `SINERGIA_CRM_EMAIL_FIELD` | Profile field for the user's email (default: `email`) |

The endpoint paths and profile field names can vary by SinergiaCRM installation.
Register the callback URL shown by OmniAuth for the `sinergia_crm` provider in
the OAuth client configuration.

Run with:

```ruby
WITH_ATENEU_BCN=1 bin/rails s
```

# Running specs:

From the main folder (one below this)

```
WITH_ATENEU_BCN=1 bundle exec rspec decidim-saas-ateneu_bcn
```
