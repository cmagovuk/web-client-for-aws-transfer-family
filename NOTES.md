## Deployment Notes

We tried to deploy this on 26/01/2022 and were not successful. This is a collection of notes which might be useful for the next attempt.

* There is a lot of unnecessary manual passing of parameters between stacks. A nested stack or automated calls to `describe_stack()` should be used to automate this. 

* There is a lot of duplication of parameters in the config scripts which are required to be run between stack deployments. Some of these scripts could be removed completely by e.g. passing in an environment variable as part of the stack definition, rather than hard-coding a parameter into a docker build. 

* The process of updating variables in-place using `sed` is **terrible**. It is not idempotent and results in super confusing errors.

* Our final outcome was a `missing cookie: 'access_token_cookie'` error on attempted login, which presumably comes from the backend process. Lambda auth logs simply show 'Failed to authenticate', so it's unclear if this is normal behaviour caused by auth failing (e.g. password getting mangled), or if something has gone wrong in the auth flow (e.g. assuming existence of jwt cookie before initial auth which creates it). If we try to deploy this again we should enable full debugging.

* We did not deploy the `07-sftp-web-client.template` because we had already set up CloudFront and Route53 pointed at the frontend bucket. This worked, but possibly some differences in our CloudFront Distribution (e.g. not including the Lambda@Edge function deployed in `06b-security-headers-lambda-edge.template`) could have caused the error we saw above, particularly since the auth flow seems to rely on the existence of certain headers.

* Our cloudfront distribution initially seemed to fail, but started working after we set the regional s3 endpoint as the origin rather than the default global one. It's unclear whether the SCP which limits lots of services to the eu-west-2 region was breaking the global origin, or if we just didn't allow enough time for the global origin to propagate.
