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
| `SINERGIA_CRM_AUTHORIZE_URL` | Authorization path (default: `/index.php?entryPoint=sticPortalLogin`) |
| `SINERGIA_CRM_TOKEN_URL` | Token path (default: `/index.php?entryPoint=sticPortalOAuthToken`) |

The token request sends the client ID and, when configured, client secret in
the POST body, as expected by SinergiaCRM's portal OAuth endpoint. Leave the
secret unset for a public OAuth client.

The token response includes the portal user ID, email, and portal type. The
strategy uses the portal type and ID together as the stable OmniAuth UID. Register
the callback URL shown by OmniAuth for the `sinergia_crm` provider in the OAuth
client configuration. The endpoint paths can be overridden for customized
installations.

Run with:

```ruby
WITH_ATENEU_BCN=1 bin/rails s
```

# Running specs:

From the main folder (one below this)

```
WITH_ATENEU_BCN=1 bundle exec rspec decidim-saas-ateneu_bcn
```
