/* 
	### 주차장 관리 테이블 3개 
*/

CREATE TABLE PRKPLCE_MNG
(
	PRKPLCE_CODE	VARCHAR(6)		NOT NULL, /* 주차장코드(대분류코드) */
	PRKPLCE_NM		VARCHAR(50)	NULL	, /* 주차장명 */
	RM				VARCHAR(200)	NULL	/* 비고 */
	
	,PRIMARY KEY (PRKPLCE_CODE)
);

CREATE UNIQUE INDEX PRKPLCE_MNG_PK ON PRKPLCE_MNG
(
	PRKPLCE_CODE
)
;

CREATE TABLE PRKPLCE_FLR_MNG
(
	PRKPLCE_CODE		VARCHAR(6)		NOT NULL,
	PRKPLCE_FLR_CODE	VARCHAR(6)		NOT NULL,
	PRKPLCE_FLR_NM		VARCHAR(200)	NULL,
	DRW_PATH			VARCHAR(200)	NULL,
	SORT				INT(2)			NULL,
	RM					VARCHAR(200)	NULL
	
	,PRIMARY KEY ( PRKPLCE_CODE, PRKPLCE_FLR_CODE )
);

CREATE UNIQUE INDEX PRKPLCE_FLR_MNG_PK ON PRKPLCE_FLR_MNG
(
	PRKPLCE_CODE, PRKPLCE_FLR_CODE
)
;


CREATE TABLE PRKPLCE_CELL_MNG
(
	PRKPLCE_CODE		VARCHAR(6)		NOT NULL,
	PRKPLCE_FLR_CODE	VARCHAR(6)		NOT NULL,
	CELL_MAPNG_ID		VARCHAR(50)		NOT NULL,
	CELL_TYPE			VARCHAR(15)		NOT NULL,
	STYLE_CLS			VARCHAR(150)	NULL	,
	SALE_CAR_INNB		VARCHAR(10)		NULL	,
	X					VARCHAR(15)		NOT NULL,
	Y					VARCHAR(15)		NOT NULL,
	WIDTH				VARCHAR(10)		NOT NULL,
	HEIGHT				VARCHAR(10)		NOT NULL
	
	
	
	,PRIMARY KEY ( PRKPLCE_CODE, PRKPLCE_FLR_CODE , CELL_MAPNG_ID)
);

CREATE UNIQUE INDEX PRKPLCE_CELL_MNG_PK ON PRKPLCE_CELL_MNG
(
	PRKPLCE_CODE, PRKPLCE_FLR_CODE , CELL_MAPNG_ID
)
;

-- 공통코드테이블 하나로 관리



/*  ====================================================================  */
/* 
	### 공통코드 테이블 3개 
	[1] 대분류코드 - CMMN_CODE_GROUP 
	[2] 중분류코드 - CMMN_CODE_DIV
	[3] 소분류코드 - CMMN_CODE_DETAIL
	
*/

-- 대분류
CREATE TABLE CMMN_CODE_GROUP
(
	GROUP_CODE		CHAR(3)		NOT NULL, /* 그룹코드(대분류코드) */
	GROUP_CODE_NM	VARCHAR(60)	NULL	, /* 그룹코드명 */
	GROUP_CODE_DC	VARCHAR(200)	NULL	, /* 그룹코드설명 */
	USE_AT			CHAR(1)		NULL	, /* 사용여부 */
	FRST_REGIST_DT	DATETIME	NULL	, /* 처음등록일시 */
	FRST_REGISTER	VARCHAR(20)	NULL	, /* 처음등록자 */
	LAST_REGIST_DT	DATETIME	NULL	, /* 마지막등록일시 */
	LAST_REGISTER	VARCHAR(20)	NULL	, /* 마지막등록자 */
	PRIMARY KEY (GROUP_CODE)
);

CREATE UNIQUE INDEX CMMN_CODE_GROUP_PK ON CMMN_CODE_GROUP
(
	GROUP_CODE
)
;



-- 중분류 
CREATE TABLE CMMN_CODE_DIV
(
	GROUP_CODE  	CHAR(3)		NULL	, /* 그룹코드(대분류코드) */    
	DIV_CODE		VARCHAR(6)	NOT NULL, /* 구분코드(중분류코드) */
	DIV_CODE_NM 	VARCHAR(60)	NULL	, /* 구분코드명 */
	DIV_CODE_DC 	VARCHAR(200)	NULL	, /* 구분코드설명 */
	USE_AT      	CHAR(1)		NULL	, /* 사용여부 */
	FRST_REGIST_DT	DATETIME	NULL	, /* 처음등록일시 */
	FRST_REGISTER 	VARCHAR(20)	NULL	, /* 처음등록자 */
	LAST_REGIST_DT	DATETIME	NULL	, /* 마지막등록일시 */
	LAST_REGISTER 	VARCHAR(20)	NULL	, /* 마지막등록자 */
	PRIMARY KEY (DIV_CODE)
);

CREATE UNIQUE INDEX CMMN_CODE_DIV_PK ON CMMN_CODE_DIV
(
	DIV_CODE
	,GROUP_CODE
);



-- 소분류
CREATE TABLE CMMN_CODE_DETAIL
(
	GROUP_CODE  	CHAR(3)		NOT NULL	, /* 그룹코드(대분류코드) */	
	DIV_CODE		VARCHAR(6)	NOT NULL, /* 분류코드(중분류코드) */
	CODE			VARCHAR(15)	NOT NULL, /* 코드(소분류코드) */
	CODE_NM			VARCHAR(60)	NULL	, /* 코드명 */
	CODE_DC			VARCHAR(200)	NULL	, /* 코드설명 */
	USE_AT			CHAR(1)		NULL	, /* 사용여부 */
	SORT			INT(3)		NULL	,
	FRST_REGIST_DT	DATETIME	NULL	, /* 처음등록일시 */
	FRST_REGISTER 	VARCHAR(20)	NULL	, /* 처음등록자 */
	LAST_REGIST_DT	DATETIME	NULL	, /* 마지막등록일시 */
	LAST_REGISTER 	VARCHAR(20)	NULL	, /* 마지막등록자 */
	PRIMARY KEY (DIV_CODE,CODE)
)
;

CREATE UNIQUE INDEX CMMN_CODE_DETAIL_PK ON CMMN_CODE_DETAIL
(
	GROUP_CODE,
	DIV_CODE,
	CODE
)
;

-- 사용자정보테이블

CREATE TABLE USER_INFO
(
	USER_ID		VARCHAR(20) NOT NULL
	,PASSWD	    VARCHAR(100)
	,EMAIL	    VARCHAR(50)
	,USER_AUTH   VARCHAR(10)
	,USER_KIND   VARCHAR(15)
	,USER_NM	    VARCHAR(15)
	,PHONE	    VARCHAR(12)
	,PRIMARY KEY (USER_ID)
);
CREATE UNIQUE INDEX USER_INFO_PK ON USER_INFO
(
	USER_ID
);

-- 기본게시판
CREATE TABLE BOARD
( 
	B_NO VARCHAR(10) NOT NULL,
	B_TYPE CHAR(2) NOT NULL,
	TITLE VARCHAR(150) NOT NULL,
	CONTENT VARCHAR(2000) NULL,
	REG_DT CHAR(20) NOT NULL,
	REG_USER_ID VARCHAR(15) NOT NULL,
	PRIMARY KEY (B_NO)
);

CREATE UNIQUE INDEX BOARD_PK ON BOARD
(
	B_NO
);

-- 게시판 첨부파일
CREATE TABLE BOARD_ATTACH
( 
	B_NO VARCHAR(10) ,
	FILE_INNB VARCHAR(10) ,
	FILE_PATHE VARCHAR(200) ,
	FILE_NM VARCHAR(100) ,
	DELETE_YN CHAR(1) ,
	REG_DT CHAR(20) ,
	REG_USER_ID VARCHAR(20) ,
	PRIMARY KEY (B_NO,FILE_INNB)
);
CREATE UNIQUE INDEX BOARD_ATTACH_PK ON BOARD_ATTACH
(
	B_NO,FILE_INNB
);

-- 판매차량정보
CREATE TABLE SELL_CAR_INFO
( 
	SELL_CAR_INNB VARCHAR(10) NOT NULL,
	CAR_DIV VARCHAR(15) NOT NULL,
	BRAND INT(9) NOT NULL,
	SERIES INT(9) NOT NULL,
	MODEL INT(9) NULL,
	LEVEL INT(9) NULL,
	MISSION VARCHAR(15) NULL,
	FURE VARCHAR(15) NULL,
	COLOR VARCHAR(15) NULL,
	REGION VARCHAR(15) NULL,
	SPOT VARCHAR(15) NULL,
	COMPANY VARCHAR(15) NULL,
	CC INT(5) NULL,
	USED_YEAR VARCHAR(6) NULL,
	USED_DIS INT(7) NULL,
	CAR_NUM VARCHAR(10) NOT NULL,
	OWNER VARCHAR(15) NOT NULL,
	OWNER_PHONE VARCHAR(12) NOT NULL,
	SALE_YN VARCHAR(1) NULL,
	PRKPLCE_CODE VARCHAR(6) NULL,
	PRKPLCE_FLR_CODE VARCHAR(6) NULL,
	CELL_MAPNG_ID VARCHAR(50) NULL,
	HOLD_YN VARCHAR(1) NULL,
	PRIMARY KEY (SELL_CAR_INNB)

);
CREATE UNIQUE INDEX SELL_CAR_INFO_PK ON SELL_CAR_INFO
(
	SELL_CAR_INNB
);

-- 차량사진테이블
CREATE TABLE CAR_PIC
( 
	SELL_CAR_INNB VARCHAR(10) ,
	PIC_INNB VARCHAR(10) ,
	FILE_PATH VARCHAR(200) ,
	FILE_NM VARCHAR(100) ,
	DELETE_YN CHAR(1) ,
	REG_DT CHAR(20) ,
	REG_USER_ID VARCHAR(20) ,

	PRIMARY KEY (SELL_CAR_INNB,PIC_INNB )

);
CREATE UNIQUE INDEX CAR_PIC_PK ON CAR_PIC
(
	SELL_CAR_INNB,PIC_INNB
);


-- 차량 정보 코드테이블
CREATE TABLE CAR_INFO
( 
	INFO_CD INT(9) NOT NULL,
	INFO_CD_NM VARCHAR(50) NOT NULL,
	P_INFO_CD INT(9) NULL,
	GRP_DIV VARCHAR(15) NULL,
	SORT INT(9) NULL,


	PRIMARY KEY ( INFO_CD )

);
CREATE UNIQUE INDEX CAR_INFO_PK ON CAR_INFO
(
	INFO_CD
);


-- 메뉴 관리 코드테이블
CREATE TABLE MENU_INFO
( 
	MENU_ID CHAR(8) NOT NULL,
	MENU_DIV CHAR(2) ,
	MENU_NM VARCHAR(40) ,
	MENU_KIND_CD CHAR(2) ,
	MENU_PID CHAR(8) ,
	MENU_URL VARCHAR(100) ,
	MENU_IMG1 VARCHAR(100) ,
	MENU_IMG2 VARCHAR(100) ,
	MENU_ICON VARCHAR(20) ,
	SORT INT(3) ,
	USE_AUTH INT(4) ,
	USE_AT CHAR(1) ,
	REG_DT CHAR(20) ,
	REG_USER_ID VARCHAR(20) ,



	PRIMARY KEY ( MENU_ID )

);
CREATE UNIQUE INDEX MENU_INFO_PK ON MENU_INFO
(
	MENU_ID
);




