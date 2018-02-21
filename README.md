# cf-plugins

## Cleanup

**Required Environment Variables**:

* `GITHUB_USERNAME` The username to use for this Pipeline job
* `BLUEMIX_ENV` Bluemix environment (`development`, `stage` or `production`)
* `GIT_URL` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)
* `GIT_COMMIT` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)
* `AIRBRAKE_PROJECT_ID` Airbrake project id
* `AIRBRAKE_PROJECT_KEY` Airbrake project key
* `AIRBRAKE_USERNAME` Name for this Toolchain job
* `CLOUDFLARE_ZONE_ID` Cloudflare zone id
* `CLOUDFLARE_USERNAME` Cloudflare account email
* `CLOUDFLARE_API_KEY` Cloudflare api key

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

* `GITHUB_USERNAME` The username to use for this Pipeline job

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

* `GITHUB_USERNAME` The username to use for this Pipeline job

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

* `GITHUB_USERNAME` The username to use for this Pipeline job

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

* `GITHUB_USERNAME` The username to use for this Pipeline job
* `BLUEMIX_ENV` Bluemix environment (`development`, `stage` or `production`)
* `CF_APP` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

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

> Git branch must be hacked using chrome HTML inspector:
>
> **from**
> `<option aria-labelledby="branch-label" value="master">master</option>`
>
> **to**
> `<option aria-labelledby="branch-label" value="develop">develop</option>`

**Input**
* Input settings
  * Input type: **Git repository**
  * Git repository: **tweak-builder**
  * Branch: **develop**
* Stage trigger
  * **Run jobs whenever a change is pushed to Git**

**Jobs**
* *Build*
  * Build configuration
    * Builder type: **npm**
    * Build script: *copy Job Integration code*
    * Working directory: *leave empty*
    * Build archive directory: **dist**
    * Enable test report: *unchecked*
    * Enable code coverage report: *unchecked*
  * Run conditions
    * Stop running this stage if this job fails: *checked*

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

**Input**
* Input settings
  * Input type: **Build artifacts**
  * Stage: **Build - Tweak Builder (Development|Stage|Production)**
  * Job: **Build**
* Stage trigger
  * **Run jobs whenever a change is pushed to Git**

**Jobs**
* *Deploy*
  * Deploy configuration
    * Deployer type: **Cloud Foundry**
    * IBM Cloud region: *choose correct region*
    * Organization: *choose correct organizaiton*
    * Space: *choose correct spact (development|stage|production)*
    * Application name: **Tweak Builder (Development|Stage|Production)**
  * Run conditions
    * Stop running this stage if this job fails: *checked*
    * Only developers in the targeted space can run this stage: *checked*

**Required Environment Variables**:

* `BLUEMIX_ENV` Bluemix environment (`development`, `stage` or `production`)
* `CF_APP` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

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

> Git branch must be hacked using chrome HTML inspector:
>
> **from**
> `<option aria-labelledby="branch-label" value="master">master</option>`
>
> **to**
> `<option aria-labelledby="branch-label" value="develop">develop</option>`

**Input**
* Input settings
  * Input type: **Git repository**
  * Git repository: **tweak-dashboard**
  * Branch: **develop**
* Stage trigger
  * **Run jobs whenever a change is pushed to Git**

**Jobs**
* *Build*
  * Build configuration
    * Builder type: **npm**
    * Build script: *copy Job Integration code*
    * Working directory: *leave empty*
    * Build archive directory: **dist**
    * Enable test report: *unchecked*
    * Enable code coverage report: *unchecked*
  * Run conditions
    * Stop running this stage if this job fails: *checked*

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

**Input**
* Input settings
  * Input type: **Build artifacts**
  * Stage: **Build - Tweak Dashboard (Development|Stage|Production)**
  * Job: **Build**
* Stage trigger
  * **Run jobs whenever a change is pushed to Git**

**Jobs**
* *Deploy*
  * Deploy configuration
    * Deployer type: **Cloud Foundry**
    * IBM Cloud region: *choose correct region*
    * Organization: *choose correct organizaiton*
    * Space: *choose correct spact (development|stage|production)*
    * Application name: **Tweak Dashboard (Development|Stage|Production)**
  * Run conditions
    * Stop running this stage if this job fails: *checked*
    * Only developers in the targeted space can run this stage: *checked*

**Required Environment Variables**:

* `BLUEMIX_ENV` Bluemix environment (`development`, `stage` or `production`)
* `CF_APP` This from [Pipeline](https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment)

**Job Integration**:

```
echo "Clone CF plugins"
git clone https://$GITHUB_USERNAME@github.com/matteo-harpoon/cf-plugins.git

echo ""
echo "Run Deploy"
chmod +x cf-plugins/steps/dashboard/deploy-bash.sh
./cf-plugins/steps/dashboard/deploy-bash.sh
```
