--
-- PostgreSQL database dump
--
-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3
-- Started on 2021-07-13 17:07:35 -03
CREATE EXTENSION "uuid-ossp";

CREATE EXTENSION "pgcrypto";

SET client_encoding = 'UTF8';

--
-- TOC entry 6 (class 2615 OID 16433)
-- Name: coins; Type: SCHEMA; Schema: -; Owner: -
--
CREATE SCHEMA coins;

--
-- TOC entry 254 (class 1255 OID 16434)
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: coins; Owner: -
--
CREATE FUNCTION coins.trigger_set_timestamp ()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 16435)
-- Name: tbl_coin_now; Type: TABLE; Schema: coins; Owner: -
--
CREATE TABLE coins.tbl_coin_now (
    name character varying(50) NOT NULL
    , created_at timestamp(0) with time zone DEFAULT now() NOT NULL
    , value numeric(10 , 2) NOT NULL
    , id uuid DEFAULT public.uuid_generate_v4 () NOT NULL
    , updated_at timestamp(0) with time zone
);

--
-- TOC entry 3068 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN tbl_coin_now.name; Type: COMMENT; Schema: coins; Owner: -
--
COMMENT ON COLUMN coins.tbl_coin_now.name IS 'coin name';

--
-- TOC entry 3069 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN tbl_coin_now.value; Type: COMMENT; Schema: coins; Owner: -
--
COMMENT ON COLUMN coins.tbl_coin_now.value IS 'actual value coin';

--
-- TOC entry 204 (class 1259 OID 16440)
-- Name: tbl_coin_posts; Type: TABLE; Schema: coins; Owner: -
--
CREATE TABLE coins.tbl_coin_posts (
    id bigint NOT NULL
    , username character varying(255) NOT NULL
    , post_text text NOT NULL
    , coin_name character varying(50) NOT NULL
);

--
-- TOC entry 3070 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN tbl_coin_posts.coin_name; Type: COMMENT; Schema: coins; Owner: -
--
COMMENT ON COLUMN coins.tbl_coin_posts.coin_name IS 'nome da moeda';

--
-- TOC entry 205 (class 1259 OID 16446)
-- Name: tbl_coin_posts_id_seq; Type: SEQUENCE; Schema: coins; Owner: -
--
ALTER TABLE coins.tbl_coin_posts
    ALTER COLUMN id
    ADD GENERATED ALWAYS AS IDENTITY (SEQUENCE NAME
        coins.tbl_coin_posts_id_seq START WITH 1 INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1);

--
-- TOC entry 206 (class 1259 OID 16448)
-- Name: tbl_coin_volume; Type: TABLE; Schema: coins; Owner: -
--
CREATE TABLE coins.tbl_coin_volume (
    id bigint NOT NULL
    , created_at timestamp(0) with time zone DEFAULT now() NOT NULL
    , updated_at timestamp(0) with time zone
    , coin_uuid uuid NOT NULL
    , buy_volume_value numeric(10 , 2) DEFAULT 0.01 NOT NULL
    , volume_date date NOT NULL
    , coin_name character varying(50)
);

--
-- TOC entry 207 (class 1259 OID 16453)
-- Name: tbl_coin_volume_id_seq; Type: SEQUENCE; Schema: coins; Owner: -
--
ALTER TABLE coins.tbl_coin_volume
    ALTER COLUMN id
    ADD GENERATED ALWAYS AS IDENTITY (SEQUENCE NAME
        coins.tbl_coin_volume_id_seq START WITH 1 INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1);

--
-- TOC entry 3058 (class 0 OID 16435)
-- Dependencies: 203
-- Data for Name: tbl_coin_now; Type: TABLE DATA; Schema: coins; Owner: -
--
INSERT INTO coins.tbl_coin_now
    VALUES ('ADA' , '2021-07-13 20:00:14+00' , 1.00 , '0b8291cb-536c-478e-85b3-4ef7d17d953d' , NULL);

INSERT INTO coins.tbl_coin_now
    VALUES ('BTC' , '2021-07-13 20:00:14+00' , 34567.88 , 'd5f79003-35af-4997-a551-6552fdaf8d0f' , NULL);

INSERT INTO coins.tbl_coin_now
    VALUES ('ETC' , '2021-07-13 20:00:14+00' , 100.55 , '8713d291-a684-496a-b3f8-4f9008b0fb30' , NULL);

INSERT INTO coins.tbl_coin_now
    VALUES ('ETH' , '2021-07-13 20:00:14+00' , 2499.99 , 'd2e2003d-7a3e-41fc-92ec-b42c550dc847' , NULL);

INSERT INTO coins.tbl_coin_now
    VALUES ('MITH' , '2021-07-13 20:00:14+00' , 0.04 , 'c5d33e69-6c3d-479c-b4f7-e751e9f747a0' , NULL);

INSERT INTO coins.tbl_coin_now
    VALUES ('HOT' , '2021-07-13 20:00:14+00' , 0.10 , '0a7a82d6-4387-41c5-8ff4-ae106f54832c' , NULL);

INSERT INTO coins.tbl_coin_now
    VALUES ('CHZ' , '2021-07-13 20:00:14+00' , 0.26 , '7d7b0c5b-5da2-4606-bc7a-9e3c1ec30f73' , NULL);

INSERT INTO coins.tbl_coin_now
    VALUES ('VET' , '2021-07-13 20:00:14+00' , 0.77 , '164a4f90-d329-42e1-b5d7-41e7147badab' , NULL);

--
-- TOC entry 3059 (class 0 OID 16440)
-- Dependencies: 204
-- Data for Name: tbl_coin_posts; Type: TABLE DATA; Schema: coins; Owner: -
--
INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (1 , 'USER1' , 'toperson' , 'ETX');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (2 , 'USER1' , 'muito boa' , 'TRX');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (3 , 'USER1' , 'lucraaaaa' , 'ETH');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (4 , 'USER1' , 'sobe mais' , 'ADA');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (5 , 'USER1' , 'estagnou' , 'BTC');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (6 , 'USER1' , 'silada bino' , 'DOGE');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (7 , 'USER2' , 'polui muito' , 'BTC');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (8 , 'USER2' , 'polui muito' , 'ETC');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (9 , 'USER2' , 'tesla vai aceitar entao vou comprar' , 'DOGE');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (10 , 'USER2' , 'essa aqui é a melhor do mundo' , 'EPY');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (11 , 'USER2' , 'brilha no corintias' , 'VET');

INSERT INTO coins.tbl_coin_posts OVERRIDING SYSTEM VALUE
    VALUES (12 , 'USER3' , 'essa é do corintias' , 'CHZ');

--
-- TOC entry 3061 (class 0 OID 16448)
-- Dependencies: 206
-- Data for Name: tbl_coin_volume; Type: TABLE DATA; Schema: coins; Owner: -
--
INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (3 , '2021-07-13 20:07:00+00' , NULL , '0b8291cb-536c-478e-85b3-4ef7d17d953d' , 1000.00 , '2021-07-13' , 'ADA');

INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (4 , '2021-07-13 20:07:00+00' , NULL , 'd5f79003-35af-4997-a551-6552fdaf8d0f' , 34567880.00 , '2021-07-13' , 'BTC');

INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (5 , '2021-07-13 20:07:00+00' , NULL , '8713d291-a684-496a-b3f8-4f9008b0fb30' , 100550.00 , '2021-07-13' , 'ETC');

INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (6 , '2021-07-13 20:07:00+00' , NULL , 'd2e2003d-7a3e-41fc-92ec-b42c550dc847' , 2499990.00 , '2021-07-13' , 'ETH');

INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (7 , '2021-07-13 20:07:00+00' , NULL , 'c5d33e69-6c3d-479c-b4f7-e751e9f747a0' , 40.00 , '2021-07-13' , 'MITH');

INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (8 , '2021-07-13 20:07:00+00' , NULL , '0a7a82d6-4387-41c5-8ff4-ae106f54832c' , 100.00 , '2021-07-13' , 'HOT');

INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (9 , '2021-07-13 20:07:00+00' , NULL , '7d7b0c5b-5da2-4606-bc7a-9e3c1ec30f73' , 260.00 , '2021-07-13' , 'CHZ');

INSERT INTO coins.tbl_coin_volume OVERRIDING SYSTEM VALUE
    VALUES (10 , '2021-07-13 20:07:00+00' , NULL , '164a4f90-d329-42e1-b5d7-41e7147badab' , 770.00 , '2021-07-13' , 'VET');

--
-- TOC entry 3071 (class 0 OID 0)
-- Dependencies: 205
-- Name: tbl_coin_posts_id_seq; Type: SEQUENCE SET; Schema: coins; Owner: -
--
SELECT
    pg_catalog.setval('coins.tbl_coin_posts_id_seq' , 12 , TRUE);

--
-- TOC entry 3072 (class 0 OID 0)
-- Dependencies: 207
-- Name: tbl_coin_volume_id_seq; Type: SEQUENCE SET; Schema: coins; Owner: -
--
SELECT
    pg_catalog.setval('coins.tbl_coin_volume_id_seq' , 11 , TRUE);

--
-- TOC entry 2916 (class 2606 OID 16456)
-- Name: tbl_coin_now tbl_coin_now_pk; Type: CONSTRAINT; Schema: coins; Owner: -
--
ALTER TABLE ONLY coins.tbl_coin_now
    ADD CONSTRAINT tbl_coin_now_pk PRIMARY KEY (id);

--
-- TOC entry 2918 (class 2606 OID 16458)
-- Name: tbl_coin_now tbl_coin_now_un; Type: CONSTRAINT; Schema: coins; Owner: -
--
ALTER TABLE ONLY coins.tbl_coin_now
    ADD CONSTRAINT tbl_coin_now_un UNIQUE (name);

--
-- TOC entry 2920 (class 2606 OID 16460)
-- Name: tbl_coin_posts tbl_coin_posts_pk; Type: CONSTRAINT; Schema: coins; Owner: -
--
ALTER TABLE ONLY coins.tbl_coin_posts
    ADD CONSTRAINT tbl_coin_posts_pk PRIMARY KEY (id);

--
-- TOC entry 2922 (class 2606 OID 16462)
-- Name: tbl_coin_volume tbl_coin_volume_pk; Type: CONSTRAINT; Schema: coins; Owner: -
--
ALTER TABLE ONLY coins.tbl_coin_volume
    ADD CONSTRAINT tbl_coin_volume_pk PRIMARY KEY (id);

--
-- TOC entry 2924 (class 2606 OID 16478)
-- Name: tbl_coin_volume tbl_coin_volume_un; Type: CONSTRAINT; Schema: coins; Owner: -
--
ALTER TABLE ONLY coins.tbl_coin_volume
    ADD CONSTRAINT tbl_coin_volume_un UNIQUE (volume_date , coin_uuid);

--
-- TOC entry 2926 (class 2620 OID 16465)
-- Name: tbl_coin_now tbl_coins_now_but; Type: TRIGGER; Schema: coins; Owner: -
--
CREATE TRIGGER tbl_coins_now_but
    BEFORE UPDATE ON coins.tbl_coin_now
    FOR EACH ROW
    EXECUTE FUNCTION coins.trigger_set_timestamp ();

--
-- TOC entry 2927 (class 2620 OID 16466)
-- Name: tbl_coin_volume tbl_coins_volume_but; Type: TRIGGER; Schema: coins; Owner: -
--
CREATE TRIGGER tbl_coins_volume_but
    BEFORE UPDATE ON coins.tbl_coin_volume
    FOR EACH ROW
    EXECUTE FUNCTION coins.trigger_set_timestamp ();

--
-- TOC entry 2925 (class 2606 OID 16472)
-- Name: tbl_coin_volume tbl_coin_volume_fk; Type: FK CONSTRAINT; Schema: coins; Owner: -
--
ALTER TABLE ONLY coins.tbl_coin_volume
    ADD CONSTRAINT tbl_coin_volume_fk FOREIGN KEY (coin_uuid) REFERENCES coins.tbl_coin_now (id);

-- Completed on 2021-07-13 17:07:35 -03
--
-- PostgreSQL database dump complete
--
