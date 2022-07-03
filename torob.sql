/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : PostgreSQL
 Source Server Version : 140002
 Source Host           : localhost:5432
 Source Catalog        : Torob
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 140002
 File Encoding         : 65001

 Date: 03/07/2022 10:31:30
*/


-- ----------------------------
-- Sequence structure for category_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."category_id_seq";
CREATE SEQUENCE "public"."category_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."category_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Sequence structure for customer_favorite_product_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."customer_favorite_product_id_seq";
CREATE SEQUENCE "public"."customer_favorite_product_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."customer_favorite_product_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Sequence structure for customer_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."customer_id_seq";
CREATE SEQUENCE "public"."customer_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."customer_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Sequence structure for owner_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."owner_id_seq";
CREATE SEQUENCE "public"."owner_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."owner_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Sequence structure for product_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."product_id_seq";
CREATE SEQUENCE "public"."product_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."product_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Sequence structure for report_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."report_id_seq";
CREATE SEQUENCE "public"."report_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."report_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Sequence structure for store_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."store_id_seq";
CREATE SEQUENCE "public"."store_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."store_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Sequence structure for store_product_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."store_product_id_seq";
CREATE SEQUENCE "public"."store_product_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1000
CACHE 1;
ALTER SEQUENCE "public"."store_product_id_seq" OWNER TO "ali_agmr";

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS "public"."category";
CREATE TABLE "public"."category" (
  "id" int4 NOT NULL DEFAULT nextval('category_id_seq'::regclass),
  "parent_id" int4,
  "name" text COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."category" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of category
-- ----------------------------
BEGIN;
INSERT INTO "public"."category" VALUES (1000, NULL, 'موبایل');
INSERT INTO "public"."category" VALUES (1001, NULL, 'تبلت');
INSERT INTO "public"."category" VALUES (1002, NULL, 'لپتاپ');
INSERT INTO "public"."category" VALUES (1003, 1000, 'موبایل سامسونگ');
INSERT INTO "public"."category" VALUES (1004, 1000, 'موبایل شیائومی');
INSERT INTO "public"."category" VALUES (1005, 1000, 'موبایل اپل');
INSERT INTO "public"."category" VALUES (1006, 1001, 'تبلت سامسونگ');
INSERT INTO "public"."category" VALUES (1007, 1001, 'تبلت شیائومی');
INSERT INTO "public"."category" VALUES (1008, 1001, 'تبلت اپل');
INSERT INTO "public"."category" VALUES (1009, 1002, 'لپتاپ لنوو');
INSERT INTO "public"."category" VALUES (1010, 1002, 'لپتاپ ایسوس');
INSERT INTO "public"."category" VALUES (1011, 1002, 'لپتاپ اپل');
COMMIT;

-- ----------------------------
-- Table structure for customer
-- ----------------------------
DROP TABLE IF EXISTS "public"."customer";
CREATE TABLE "public"."customer" (
  "id" int4 NOT NULL DEFAULT nextval('customer_id_seq'::regclass),
  "username" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."customer" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of customer
-- ----------------------------
BEGIN;
INSERT INTO "public"."customer" VALUES (1000, 'ali_agmr', '12345678', 'aghamirya@gmail.com');
INSERT INTO "public"."customer" VALUES (1001, 'ali_agmr2', 'PPpp8888', 'ali@gmail.com');
INSERT INTO "public"."customer" VALUES (1005, 'ali', '1234ABcd', 'ali2@gmail.com');
COMMIT;

-- ----------------------------
-- Table structure for customer_favorite_product
-- ----------------------------
DROP TABLE IF EXISTS "public"."customer_favorite_product";
CREATE TABLE "public"."customer_favorite_product" (
  "id" int4 NOT NULL DEFAULT nextval('customer_favorite_product_id_seq'::regclass),
  "customer_id" int4 NOT NULL,
  "product_id" int4 NOT NULL
)
;
ALTER TABLE "public"."customer_favorite_product" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of customer_favorite_product
-- ----------------------------
BEGIN;
INSERT INTO "public"."customer_favorite_product" VALUES (1015, 1000, 1001);
INSERT INTO "public"."customer_favorite_product" VALUES (1016, 1000, 1000);
COMMIT;

-- ----------------------------
-- Table structure for owner
-- ----------------------------
DROP TABLE IF EXISTS "public"."owner";
CREATE TABLE "public"."owner" (
  "id" int4 NOT NULL DEFAULT nextval('owner_id_seq'::regclass),
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "phone_number" text COLLATE "pg_catalog"."default" NOT NULL,
  "email" text COLLATE "pg_catalog"."default" NOT NULL,
  "username" text COLLATE "pg_catalog"."default" NOT NULL,
  "password" text COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."owner" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of owner
-- ----------------------------
BEGIN;
INSERT INTO "public"."owner" VALUES (1000, 'ali aghamiri', '989039945333', 'aghamirya@gmail.com', 'ali_agmr', '12345678');
COMMIT;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS "public"."product";
CREATE TABLE "public"."product" (
  "id" int4 NOT NULL DEFAULT nextval('product_id_seq'::regclass),
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "category_id" int4 NOT NULL,
  "processor" text COLLATE "pg_catalog"."default" NOT NULL,
  "ram" text COLLATE "pg_catalog"."default" NOT NULL,
  "battery" text COLLATE "pg_catalog"."default" NOT NULL,
  "dimensions" text COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."product" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of product
-- ----------------------------
BEGIN;
INSERT INTO "public"."product" VALUES (1000, 'samsung note 10 lite', 'good phone', 1003, 'snapdragon 810', '8 gb', '3500 mA', '6.1 inch');
INSERT INTO "public"."product" VALUES (1001, 'apple iPhone 13', 'perfect phone', 1005, 'A15', '16 gb', '5000 mA', '6.5 inch');
INSERT INTO "public"."product" VALUES (1002, 'test', 'test', 1010, 'test', 'test', 'test', 'test');
INSERT INTO "public"."product" VALUES (1003, 'test', 'test', 1007, 'test', 'test', 'test', 'test');
INSERT INTO "public"."product" VALUES (1004, 'test', 'test', 1011, 'test', 'test', 'test', 'test');
INSERT INTO "public"."product" VALUES (1005, 'test', 'test', 1011, 'test', 'test', 'test', 'test');
INSERT INTO "public"."product" VALUES (1006, 'test', 'test', 1011, 'test', 'test', 'test', 'test');
COMMIT;

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS "public"."report";
CREATE TABLE "public"."report" (
  "id" int4 NOT NULL DEFAULT nextval('report_id_seq'::regclass),
  "store_id" int4 NOT NULL,
  "report_type" int4 NOT NULL,
  "customer_id" int4,
  "product_id" int4 NOT NULL
)
;
ALTER TABLE "public"."report" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of report
-- ----------------------------
BEGIN;
INSERT INTO "public"."report" VALUES (1002, 1000, 1, 1000, 1001);
INSERT INTO "public"."report" VALUES (1003, 1001, 1, 1000, 1001);
INSERT INTO "public"."report" VALUES (1004, 1000, 1, 1000, 1001);
INSERT INTO "public"."report" VALUES (1005, 1001, 1, 1000, 1001);
INSERT INTO "public"."report" VALUES (1006, 1000, 1, 1000, 1001);
INSERT INTO "public"."report" VALUES (1007, 1001, 2, 1000, 1001);
INSERT INTO "public"."report" VALUES (1008, 1000, 2, 1000, 1001);
COMMIT;

-- ----------------------------
-- Table structure for store
-- ----------------------------
DROP TABLE IF EXISTS "public"."store";
CREATE TABLE "public"."store" (
  "id" int4 NOT NULL DEFAULT nextval('store_id_seq'::regclass),
  "name" text COLLATE "pg_catalog"."default" NOT NULL,
  "owner_id" int4 NOT NULL,
  "link" text COLLATE "pg_catalog"."default" NOT NULL,
  "phone_number" text COLLATE "pg_catalog"."default",
  "address" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."store" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of store
-- ----------------------------
BEGIN;
INSERT INTO "public"."store" VALUES (1000, 'digikala', 1000, 'digikala.com', NULL, NULL);
INSERT INTO "public"."store" VALUES (1001, 'digikala2', 1000, 'digikala2.com', NULL, NULL);
INSERT INTO "public"."store" VALUES (1002, 'digikala3', 1000, 'digikala3.com', '02111111111', 'تهران');
INSERT INTO "public"."store" VALUES (1003, 'digikala4', 1000, 'digikala4.com', '02111111111', 'تهران');
COMMIT;

-- ----------------------------
-- Table structure for store_product
-- ----------------------------
DROP TABLE IF EXISTS "public"."store_product";
CREATE TABLE "public"."store_product" (
  "id" int4 NOT NULL DEFAULT nextval('store_product_id_seq'::regclass),
  "store_id" int4 NOT NULL,
  "product_id" int4 NOT NULL,
  "price" text COLLATE "pg_catalog"."default" NOT NULL,
  "link" text COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."store_product" OWNER TO "ali_agmr";

-- ----------------------------
-- Records of store_product
-- ----------------------------
BEGIN;
INSERT INTO "public"."store_product" VALUES (1000, 1000, 1000, '50000', 'digikala.com/product/1000');
INSERT INTO "public"."store_product" VALUES (1001, 1001, 1000, '30000', 'digikala2.com/product/1000');
INSERT INTO "public"."store_product" VALUES (1002, 1000, 1001, '80000', 'digikala.com/product/1001');
INSERT INTO "public"."store_product" VALUES (1003, 1001, 1001, '100000', 'digikala2.com/product/1001');
INSERT INTO "public"."store_product" VALUES (1004, 1002, 1001, '25000', 'digikala3.com/product/this');
INSERT INTO "public"."store_product" VALUES (1005, 1003, 1006, '1000', 'digikala4.com/product/hey');
COMMIT;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."category_id_seq"
OWNED BY "public"."category"."id";
SELECT setval('"public"."category_id_seq"', 1012, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."customer_favorite_product_id_seq"
OWNED BY "public"."customer_favorite_product"."id";
SELECT setval('"public"."customer_favorite_product_id_seq"', 1017, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."customer_id_seq"
OWNED BY "public"."customer"."id";
SELECT setval('"public"."customer_id_seq"', 1006, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."owner_id_seq"
OWNED BY "public"."owner"."id";
SELECT setval('"public"."owner_id_seq"', 1001, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."product_id_seq"
OWNED BY "public"."product"."id";
SELECT setval('"public"."product_id_seq"', 1007, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."report_id_seq"
OWNED BY "public"."report"."id";
SELECT setval('"public"."report_id_seq"', 1009, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."store_id_seq"
OWNED BY "public"."store"."id";
SELECT setval('"public"."store_id_seq"', 1004, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."store_product_id_seq"
OWNED BY "public"."store_product"."id";
SELECT setval('"public"."store_product_id_seq"', 1006, true);

-- ----------------------------
-- Primary Key structure for table category
-- ----------------------------
ALTER TABLE "public"."category" ADD CONSTRAINT "category_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table customer
-- ----------------------------
CREATE UNIQUE INDEX "customer_id_uindex" ON "public"."customer" USING btree (
  "id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "customer_username_uindex" ON "public"."customer" USING btree (
  "username" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table customer
-- ----------------------------
ALTER TABLE "public"."customer" ADD CONSTRAINT "customer_pk" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table customer_favorite_product
-- ----------------------------
CREATE UNIQUE INDEX "customer_favorite_product_id_uindex" ON "public"."customer_favorite_product" USING btree (
  "id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table customer_favorite_product
-- ----------------------------
ALTER TABLE "public"."customer_favorite_product" ADD CONSTRAINT "customer_favorite_product_pk" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table owner
-- ----------------------------
ALTER TABLE "public"."owner" ADD CONSTRAINT "owner_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table product
-- ----------------------------
CREATE UNIQUE INDEX "product_id_uindex" ON "public"."product" USING btree (
  "id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table product
-- ----------------------------
ALTER TABLE "public"."product" ADD CONSTRAINT "product_pk" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table report
-- ----------------------------
CREATE UNIQUE INDEX "report_id_uindex" ON "public"."report" USING btree (
  "id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table report
-- ----------------------------
ALTER TABLE "public"."report" ADD CONSTRAINT "report_pk" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table store
-- ----------------------------
CREATE UNIQUE INDEX "store_id_uindex" ON "public"."store" USING btree (
  "id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table store
-- ----------------------------
ALTER TABLE "public"."store" ADD CONSTRAINT "store_pk" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table store_product
-- ----------------------------
CREATE UNIQUE INDEX "store_product_id_uindex" ON "public"."store_product" USING btree (
  "id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table store_product
-- ----------------------------
ALTER TABLE "public"."store_product" ADD CONSTRAINT "store_product_pk" PRIMARY KEY ("id");
