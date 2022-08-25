# Equinix Metal helm charts

This repo facilitates the import of helm charts from equinixmetal-helm.github.io

## Adding new projects

This repo uses GNU `date` and `sed` which is installed with `brew install gnu-sed coreutils` on Mac OS.

To create a helm chart release run:

```
./prepare-artifacts.sh <chart-name>
```

Where `chart-name`, is the repo name in the equinixmetal-helm org.

Then commit your changes and submit a PR.
