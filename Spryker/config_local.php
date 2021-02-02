<?php
use Pyz\Shared\Scheduler\SchedulerConfig;
use Spryker\Shared\Application\ApplicationConstants;
use Spryker\Shared\Collector\CollectorConstants;
use Spryker\Shared\Customer\CustomerConstants;
use Spryker\Shared\Event\EventConstants;
use Spryker\Shared\GlueApplication\GlueApplicationConstants;
use Spryker\Shared\Kernel\KernelConstants;
use Spryker\Shared\Newsletter\NewsletterConstants;
use Spryker\Shared\Oauth\OauthConstants;
use Spryker\Shared\ProductManagement\ProductManagementConstants;
use Spryker\Shared\PropelQueryBuilder\PropelQueryBuilderConstants;
use Spryker\Shared\Propel\PropelConstants;
use Spryker\Shared\RabbitMq\RabbitMqEnv;
use Spryker\Shared\Router\RouterConstants;
use Spryker\Shared\Search\SearchConstants;
use Spryker\Shared\SearchElasticsearch\SearchElasticsearchConstants;
use Spryker\Shared\Scheduler\SchedulerConstants;
use Spryker\Shared\SchedulerJenkins\SchedulerJenkinsConfig;
use Spryker\Shared\SchedulerJenkins\SchedulerJenkinsConstants;
use Spryker\Shared\Session\SessionConstants;
use Spryker\Shared\Session\SessionConfig;
use Spryker\Shared\SessionFile\SessionFileConstants;
use Spryker\Shared\SessionRedis\SessionRedisConfig;
use Spryker\Shared\SessionRedis\SessionRedisConstants;
use Spryker\Shared\StorageRedis\StorageRedisConstants;
use Spryker\Shared\Setup\SetupConstants;
use Spryker\Shared\Storage\StorageConstants;
use Spryker\Shared\Twig\TwigConstants;
use Spryker\Shared\ZedNavigation\ZedNavigationConstants;
use Spryker\Shared\ZedRequest\ZedRequestConstants;


// ---------- KV storage
$config[StorageConstants::STORAGE_KV_SOURCE] = 'redis';

$config[StorageRedisConstants::STORAGE_REDIS_PERSISTENT_CONNECTION] = true;
$config[StorageRedisConstants::STORAGE_REDIS_PROTOCOL] = 'redis';
$config[StorageRedisConstants::STORAGE_REDIS_HOST] = '{{REDIS_ENDPOINT}}';
$config[StorageRedisConstants::STORAGE_REDIS_PORT] = '6379';
$config[StorageRedisConstants::STORAGE_REDIS_PASSWORD] = false;
$config[StorageRedisConstants::STORAGE_REDIS_DATABASE] = 0;

// ---------- Session
$config[SessionConstants::YVES_SESSION_SAVE_HANDLER] = SessionRedisConfig::SESSION_HANDLER_REDIS_LOCKING;
$config[SessionConstants::YVES_SESSION_TIME_TO_LIVE] = SessionConfig::SESSION_LIFETIME_1_HOUR;
$config[SessionRedisConstants::YVES_SESSION_TIME_TO_LIVE] = $config[SessionConstants::YVES_SESSION_TIME_TO_LIVE];
$config[SessionFileConstants::YVES_SESSION_TIME_TO_LIVE] = $config[SessionConstants::YVES_SESSION_TIME_TO_LIVE];
$config[SessionConstants::YVES_SESSION_COOKIE_TIME_TO_LIVE] = SessionConfig::SESSION_LIFETIME_0_5_HOUR;
$config[SessionFileConstants::YVES_SESSION_FILE_PATH] = session_save_path();
$config[SessionConstants::YVES_SESSION_PERSISTENT_CONNECTION] = $config[StorageRedisConstants::STORAGE_REDIS_PERSISTENT_CONNECTION];
$config[SessionConstants::ZED_SESSION_SAVE_HANDLER] = SessionRedisConfig::SESSION_HANDLER_REDIS;
$config[SessionConstants::ZED_SESSION_TIME_TO_LIVE] = SessionConfig::SESSION_LIFETIME_1_HOUR;
$config[SessionRedisConstants::ZED_SESSION_TIME_TO_LIVE] = $config[SessionConstants::ZED_SESSION_TIME_TO_LIVE];
$config[SessionFileConstants::ZED_SESSION_TIME_TO_LIVE] = $config[SessionConstants::ZED_SESSION_TIME_TO_LIVE];
$config[SessionConstants::ZED_SESSION_COOKIE_TIME_TO_LIVE] = SessionConfig::SESSION_LIFETIME_BROWSER_SESSION;
$config[SessionFileConstants::ZED_SESSION_FILE_PATH] = session_save_path();
$config[SessionConstants::ZED_SESSION_PERSISTENT_CONNECTION] = $config[StorageRedisConstants::STORAGE_REDIS_PERSISTENT_CONNECTION];
$config[SessionRedisConstants::LOCKING_TIMEOUT_MILLISECONDS] = 0;
$config[SessionRedisConstants::LOCKING_RETRY_DELAY_MICROSECONDS] = 0;
$config[SessionRedisConstants::LOCKING_LOCK_TTL_MILLISECONDS] = 0;

$config[SessionRedisConstants::YVES_SESSION_REDIS_PROTOCOL] = $config[StorageRedisConstants::STORAGE_REDIS_PROTOCOL];
$config[SessionRedisConstants::YVES_SESSION_REDIS_HOST] = $config[StorageRedisConstants::STORAGE_REDIS_HOST];
$config[SessionRedisConstants::YVES_SESSION_REDIS_PORT] = $config[StorageRedisConstants::STORAGE_REDIS_PORT];
$config[SessionRedisConstants::YVES_SESSION_REDIS_PASSWORD] = $config[StorageRedisConstants::STORAGE_REDIS_PASSWORD];
$config[SessionRedisConstants::YVES_SESSION_REDIS_DATABASE] = 1;

$config[SessionRedisConstants::ZED_SESSION_REDIS_PROTOCOL] = $config[StorageRedisConstants::STORAGE_REDIS_PROTOCOL];
$config[SessionRedisConstants::ZED_SESSION_REDIS_HOST] = $config[StorageRedisConstants::STORAGE_REDIS_HOST];
$config[SessionRedisConstants::ZED_SESSION_REDIS_PORT] = $config[StorageRedisConstants::STORAGE_REDIS_PORT];
$config[SessionRedisConstants::ZED_SESSION_REDIS_PASSWORD] = $config[StorageRedisConstants::STORAGE_REDIS_PASSWORD];
$config[SessionRedisConstants::ZED_SESSION_REDIS_DATABASE] = 2;

/** Database credentials **/
$config[PropelConstants::ZED_DB_USERNAME] = '{{RDS_USERNAME}}';
$config[PropelConstants::ZED_DB_PASSWORD] = '{{RDS_PASSWORD}}';
$config[PropelConstants::ZED_DB_HOST] = '{{RDS_ENDPOINT}}';
$config[PropelConstants::ZED_DB_PORT] = '5432';
$config[PropelConstants::ZED_DB_ENGINE]
    = $config[PropelQueryBuilderConstants::ZED_DB_ENGINE]
    = $config[PropelConstants::ZED_DB_ENGINE_PGSQL];
$config[PropelConstants::USE_SUDO_TO_MANAGE_DATABASE] = false;


/** Elasticsearch  */
$config[ApplicationConstants::ELASTICA_PARAMETER__HOST] = '{{ELASTICSEARCH_ENDPOINT}}';
$config[ApplicationConstants::ELASTICA_PARAMETER__PORT] = '443';
$config[ApplicationConstants::ELASTICA_PARAMETER__INDEX_NAME]
    = $config[CollectorConstants::ELASTICA_PARAMETER__INDEX_NAME]
    = $config[SearchConstants::ELASTICA_PARAMETER__INDEX_NAME]
    = 'de_search';
unset($config[SearchConstants::ELASTICA_PARAMETER__AUTH_HEADER]);
$ELASTICA_PARAMETER__EXTRA = [
    // AWS ElasticSearch service additional parameters for aws/aws-sdk-php module
    //'aws_region' => 'eu-central-1',
    //'transport' => 'AwsAuthV4'
];
$config[ApplicationConstants::ELASTICA_PARAMETER__EXTRA] = $ELASTICA_PARAMETER__EXTRA;
$config[SearchConstants::ELASTICA_PARAMETER__EXTRA] = $ELASTICA_PARAMETER__EXTRA;

$config[SearchConstants::ELASTICA_PARAMETER__HOST]
    = $config[SearchElasticsearchConstants::HOST] = '{{ELASTICSEARCH_ENDPOINT}}';
$config[SearchConstants::ELASTICA_PARAMETER__PORT]
    = $config[SearchElasticsearchConstants::PORT] = '443';
$config[SearchConstants::ELASTICA_PARAMETER__EXTRA]
    = $config[SearchElasticsearchConstants::EXTRA] = $ELASTICA_PARAMETER__EXTRA;

// ---------- Scheduler
$config[SchedulerConstants::ENABLED_SCHEDULERS] = [
    SchedulerConfig::SCHEDULER_JENKINS,
];
$config[SchedulerJenkinsConstants::JENKINS_CONFIGURATION] = [
    SchedulerConfig::SCHEDULER_JENKINS => [
        SchedulerJenkinsConfig::SCHEDULER_JENKINS_BASE_URL => 'http://' . 'localhost' . ':' . '8080' . '/',
    ],
];


/** RabbitMQ **/
$config[RabbitMqEnv::RABBITMQ_API_HOST] = '{{RABBITMQ_HOST}}';
$config[RabbitMqEnv::RABBITMQ_API_PORT] = '15672';
$config[RabbitMqEnv::RABBITMQ_API_USERNAME] = '{{RABBITMQ_USERNAME}}';
$config[RabbitMqEnv::RABBITMQ_API_PASSWORD] = '{{RABBITMQ_PASSWORD}}';

/** Debugging **/
$config[EventConstants::LOGGER_ACTIVE] = true;

/** Add Glue API auth parameters **/
$config[OauthConstants::PRIVATE_KEY_PATH] = 'file://' . APPLICATION_ROOT_DIR . '/config/Zed/dev_only_private.key';
$config[OauthConstants::PUBLIC_KEY_PATH] = 'file://' . APPLICATION_ROOT_DIR . '/config/Zed/dev_only_public.key';

/** Optimizing **/
/** Deactivate All Debug Functions And the Symfony Toolbar **/
$config[ApplicationConstants::ENABLE_APPLICATION_DEBUG] = false;
$config[ApplicationConstants::ENABLE_WEB_PROFILER] = false;
$config[PropelConstants::PROPEL_DEBUG] = false;

/** Activate Twig Compiler **/
$config[TwigConstants::ZED_TWIG_OPTIONS] = [
   'cache' => new Twig_Cache_Filesystem(sprintf(
	'%s/data/%s/cache/Zed/twig',
	 APPLICATION_ROOT_DIR, 'DE'),
	 Twig_Cache_Filesystem::FORCE_BYTECODE_INVALIDATION),
];

$config[TwigConstants::YVES_TWIG_OPTIONS] = [
    'cache' => new Twig_Cache_Filesystem(sprintf(
	'%s/data/%s/cache/Yves/twig',
	 APPLICATION_ROOT_DIR, 'DE'),
	 Twig_Cache_Filesystem::FORCE_BYTECODE_INVALIDATION),
];

/** Activate Twig Path Cache **/
$config[TwigConstants::YVES_PATH_CACHE_FILE] = sprintf(
    '%s/data/%s/cache/Yves/twig/.pathCache',
    APPLICATION_ROOT_DIR,
    'DE'
);
$config[TwigConstants::ZED_PATH_CACHE_FILE] = sprintf(
    '%s/data/%s/cache/Zed/twig/.pathCache',
    APPLICATION_ROOT_DIR,
    'DE'
);

/** Activate Zed Navigation Cache (Default On) **/
$config[ZedNavigationConstants::ZED_NAVIGATION_CACHE_ENABLED] = true;

/** Activate Class Resolver Cache **/
$config[KernelConstants::AUTO_LOADER_UNRESOLVABLE_CACHE_ENABLED] = true;

// ---------- Routing
$config[ApplicationConstants::YVES_SSL_ENABLED] = false;
$config[ApplicationConstants::ZED_SSL_ENABLED] = false;

$config[RouterConstants::YVES_IS_SSL_ENABLED] = false;
$config[RouterConstants::ZED_IS_SSL_ENABLED] = false;

// ---------- Session
$config[SessionConstants::YVES_SESSION_COOKIE_SECURE] = false;
$config[SessionConstants::ZED_SESSION_COOKIE_SECURE] = false;
$config[SessionConstants::ZED_SESSION_TIME_TO_LIVE] = SessionConfig::SESSION_LIFETIME_1_YEAR;
$config[SessionRedisConstants::ZED_SESSION_TIME_TO_LIVE] = $config[SessionConstants::ZED_SESSION_TIME_TO_LIVE];
$config[SessionFileConstants::ZED_SESSION_TIME_TO_LIVE] = $config[SessionConstants::ZED_SESSION_TIME_TO_LIVE];
