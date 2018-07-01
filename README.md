Testing solution for OpenJDK for ev3dev
=======================================

[**View on AdoptOpenJDK CI**](https://ci.adoptopenjdk.net/view/ev3dev/)

There are currently three ways to the tests:

1. **Jenkinsfile**

Just add pipeline from this repo to Jenkins. Tests are configured in the Jenkinsfile at the top in the `jdkMap` associative array.

For each test a separate stage will be generated.

2. **Dockerfile**

You can run the provided Docker container. Tests are executed in the `/opt/jdktest/` directory.

```
docker build -t openjdk-10-ev3-test .
docker run openjdk-10-ev3-test
```

It will run all tests enabled in `mktest.sh` in function `test_run`. To extract the results, you can add a volume mount from the host to `/opt/jdktest`.

3. **Just a shell script**

Simply run `mktest.sh` and tests will be executed in the directory containing the script.
