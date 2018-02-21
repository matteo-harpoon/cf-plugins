# cf-plugins

## Cleanup

**Required Environment Variables**:

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Cleanup"
chmod +x cf-plugins/cleanup/cleanup-bash.sh
./cf-plugins/cleanup/cleanup-bash.sh
```

## Steps

### API

#### Flow

```
Build -> Lint -> Test -> Deploy -> Cleanup
```

#### Build

**Required Environment Variables**:

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Build"
chmod +x cf-plugins/steps/api/build-bash.sh
./cf-plugins/steps/api/build-bash.sh
```

#### Lint

**Required Environment Variables**:

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Lint"
chmod +x cf-plugins/steps/api/lint-bash.sh
./cf-plugins/steps/api/lint-bash.sh
```

#### Test

**Required Environment Variables**:

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Test"
chmod +x cf-plugins/steps/api/test-bash.sh
./cf-plugins/steps/api/test-bash.sh
```

#### Deploy

**Required Environment Variables**:

* BLUEMIX_ENV This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)
* CF_APP This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Deploy"
chmod +x cf-plugins/steps/api/deploy-bash.sh
./cf-plugins/steps/api/deploy-bash.sh
```

### SDK

#### Flow

```
Generate
```

#### Generate

**Required Environment Variables**:

* `BLUEMIX_ENV` Bluemix environment (`development`, `stage` or `production`)
* `GIT_BRANCH` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)
* `GITHUB_USER_NAME` A name and surname for this Pipeline job
* `GITHUB_USER_EMAIL` An email for this Pipeline job
* `GITHUB_USERNAME` The username to use for this Pipeline job
* `GITHUB_PASSWORD` The application token to use for this Pipeline job

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Generate"
chmod +x cf-plugins/steps/sdk/generate-js-unified-bash.sh
./cf-plugins/steps/sdk/generate-js-unified-bash.sh
```

### Builder

#### Flow

```
Build -> Deploy -> Cleanup
```

#### Build

**Required Environment Variables**:

* `BLUEMIX_ENV` Bluemix environment (`development`, `stage` or `production`)
* `ARCHIVE_DIR` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Build"
chmod +x cf-plugins/steps/builder/build-bash.sh
./cf-plugins/steps/builder/build-bash.sh
```

#### Deploy

**Required Environment Variables**:

* BLUEMIX_ENV This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)
* CF_APP This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Deploy"
chmod +x cf-plugins/steps/builder/deploy-bash.sh
./cf-plugins/steps/builder/deploy-bash.sh
```

### Dashboard

#### Flow

```
Build -> Deploy -> Cleanup
```

#### Build

**Required Environment Variables**:

* `BLUEMIX_ENV` Bluemix environment (`development`, `stage` or `production`)
* `ARCHIVE_DIR` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Build"
chmod +x cf-plugins/steps/dashboard/build-bash.sh
./cf-plugins/steps/dashboard/build-bash.sh
```

#### Deploy

**Required Environment Variables**:

* BLUEMIX_ENV This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)
* CF_APP This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Deploy"
chmod +x cf-plugins/steps/dashboard/deploy-bash.sh
./cf-plugins/steps/dashboard/deploy-bash.sh
```
