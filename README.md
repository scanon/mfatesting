## Docker-ized SSH for testing MFA


This currently is configured with Google Authenticator but can be adopted for other purposes.


## Running the server

    docker run -d -v /dev/log:/dev/log -v /global:/global -v /your/config:/config -p 2222:22 scanon/mfatesting


## Generating a key

To make it easy to generate a key, the entrypoint includes an option to generate a key.

On your laptop or other Docker-enabled system run...


    docker run -it --rm scanon/mfatesting  "canon@nersc"

This will generate a QR code that you can scan on your phone.  It will also print out the text that needs to be
added to a ".google_authenticator" file in your target home directory.  Be sure to change the permisions to read-only
after adding the text.

    vi ~/.google_authenticator
    #<paste text>
    chmod 400 ~/.google_authenticator


## Testing

You should be able to ssh to the test host using the specified port (2222 in this example).

    ssh -p 2222 <user>@<testhost> 

If things are configured correctly, you should see a prompt for a "Password & verification code:".
