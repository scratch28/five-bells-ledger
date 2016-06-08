create table if not exists "L_ACCOUNTS" (
"ACCOUNT_ID" serial not null primary key,
"NAME" varchar(255),
"BALANCE" numeric(32,16) check ("BALANCE" >= "MINIMUM_ALLOWED_BALANCE"),
"CONNECTOR" varchar(1024),
"PASSWORD_HASH" varchar(1024),
"PUBLIC_KEY" text,
"IS_ADMIN" boolean,
"IS_DISABLED" boolean,
"FINGERPRINT" varchar(255),
"MINIMUM_ALLOWED_BALANCE" numeric(32,16) default 0);

create unique index accounts_name_unique on "L_ACCOUNTS" ("NAME");
create index fingerprint on "L_ACCOUNTS" ("FINGERPRINT");


create table if not exists "L_TRANSFERS" (
"TRANSFER_ID" char(36) not null primary key,
"LEDGER" varchar(1024),
"DEBITS" text,
"CREDITS" text,
"ADDITIONAL_INFO" text,
"STATE" varchar,
"REJECTION_REASON" varchar,
"EXECUTION_CONDITION" text,
"CANCELLATION_CONDITION" text,
"EXPIRES_AT" timestamp,
"PROPOSED_AT" timestamp,
"PREPARED_AT" timestamp,
"EXECUTED_AT" timestamp,
"REJECTED_AT" timestamp);

create table if not exists "subscriptions" (
"id" char(36) not null primary key,
"owner" varchar(1024),
"event" varchar(255),
"subject" varchar(1024),
"target" varchar(1024),
"is_deleted" boolean default FALSE);

create index subscriptions_id_is_deleted_index
  on "subscriptions" ("id", "is_deleted");


create table if not exists "notifications" (
"id" char(36) not null primary key,
"subscription_id" char(36),
"transfer_id" char(36),
"retry_count" integer,
"retry_at" timestamp);

create index notifications_retry_at_index on "notifications" ("retry_at");
create index subscription_transfer
  on "notifications" ("subscription_id", "transfer_id");


create table if not exists "entries" (
"id" serial not null primary key,
"transfer_id" char(36),
"account" integer,
"created_at" timestamp default CURRENT_TIMESTAMP);


create table if not exists "fulfillments" (
"id" serial not null primary key,
"transfer_id" char(36),
"condition_fulfillment" text);

create index fulfillments_transfer_id_index on "fulfillments" ("transfer_id");
