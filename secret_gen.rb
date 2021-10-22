require "jwt"

key_file = "AuthKey_778J6692PU_appleSignInSupabase.p8"
team_id = "3LPB24TZ75"
client_id = "com.coneplay.app.service.id"
key_id = "778J6692PU"

validity_period = 180 # In days. Max 180 (6 months) according to Apple docs.

private_key = OpenSSL::PKey::EC.new IO.read key_file

token = JWT.encode(
    {
        iss: team_id,
        iat: Time.now.to_i,
        exp: Time.now.to_i + 86400 * validity_period,
        aud: "https://appleid.apple.com",
        sub: client_id
    },
    private_key,
    "ES256",
    header_fields=
    {
        kid: key_id 
    }
)
puts token