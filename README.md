# Equinix Metal helm charts

This repo facilitates the import of helm charts from equinixmetal-helm.github.io at [`helm.equinixmetal.com`](https://github.com/equinixmetal-helm/charts/tree/gh-pages)

## Adding new projects

This repo uses GNU `date` and `sed` which is installed with `brew install gnu-sed coreutils` on Mac OS.

To create a helm chart release run:

```
./prepare-artifacts.sh /path/to/chart-dir
```

Where `chart-dir`, is a local directory containing the helm chart you wish to package.

Then commit your changes and submit a PR to the [`gh-pages`](https://github.com/equinixmetal-helm/charts/tree/gh-pages) branch.

Some upstream repositories publish their charts via automation. You do not need to use the above script unless manually generating the chart.
