# Equinix Metal helm charts

This repo facilitates the import of helm charts from equinixmetal-helm.github.io

## Adding new projects

This repo uses GNU `date` and `sed` which is installed with `brew install gnu-sed coreutils` on Mac OS.

To create a helm chart release run:

```
./prepare-artifacts.sh /path/to/chart-dir
```

Where `chart-dir`, is a local directory containing the helm chart you wish to package.

Then commit your changes and submit a PR.
