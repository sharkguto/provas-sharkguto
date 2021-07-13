--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

-- Started on 2021-07-13 15:23:28 -03

CREATE EXTENSION "uuid-ossp";
CREATE EXTENSION "pgcrypto";
SET client_encoding = 'UTF8';


--
-- TOC entry 8 (class 2615 OID 16385)
-- Name: coins; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA coins;


--
-- TOC entry 254 (class 1255 OID 16446)
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: coins; Owner: -
--

CREATE FUNCTION coins.trigger_set_timestamp() RETURNS trigger
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
-- TOC entry 203 (class 1259 OID 16388)
-- Name: tbl_coin_now; Type: TABLE; Schema: coins; Owner: -
--

CREATE TABLE coins.tbl_coin_now (
    name character varying(50) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT now() NOT NULL,
    value numeric(10,2) NOT NULL,
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    updated_at timestamp(0) with time zone
);


--
-- TOC entry 3069 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN tbl_coin_now.name; Type: COMMENT; Schema: coins; Owner: -
--

COMMENT ON COLUMN coins.tbl_coin_now.name IS 'coin name';


--
-- TOC entry 3070 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN tbl_coin_now.value; Type: COMMENT; Schema: coins; Owner: -
--

COMMENT ON COLUMN coins.tbl_coin_now.value IS 'actual value coin';


--
-- TOC entry 207 (class 1259 OID 16469)
-- Name: tbl_coin_posts; Type: TABLE; Schema: coins; Owner: -
--

CREATE TABLE coins.tbl_coin_posts (
    id bigint NOT NULL,
    coin_uuid uuid,
    username character varying(255) NOT NULL,
    post_text text NOT NULL
);


--
-- TOC entry 206 (class 1259 OID 16467)
-- Name: tbl_coin_posts_id_seq; Type: SEQUENCE; Schema: coins; Owner: -
--

ALTER TABLE coins.tbl_coin_posts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME coins.tbl_coin_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 16452)
-- Name: tbl_coin_volume; Type: TABLE; Schema: coins; Owner: -
--

CREATE TABLE coins.tbl_coin_volume (
    id bigint NOT NULL,
    created_at timestamp(0) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(0) with time zone,
    coin_uuid uuid NOT NULL,
    buy_volume_value numeric(10,2) DEFAULT 0.01 NOT NULL,
    volume_date date NOT NULL
);


--
-- TOC entry 204 (class 1259 OID 16450)
-- Name: tbl_coin_volume_id_seq; Type: SEQUENCE; Schema: coins; Owner: -
--

ALTER TABLE coins.tbl_coin_volume ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME coins.tbl_coin_volume_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3059 (class 0 OID 16388)
-- Dependencies: 203
-- Data for Name: tbl_coin_now; Type: TABLE DATA; Schema: coins; Owner: -
--



--
-- TOC entry 3063 (class 0 OID 16469)
-- Dependencies: 207
-- Data for Name: tbl_coin_posts; Type: TABLE DATA; Schema: coins; Owner: -
--



--
-- TOC entry 3061 (class 0 OID 16452)
-- Dependencies: 205
-- Data for Name: tbl_coin_volume; Type: TABLE DATA; Schema: coins; Owner: -
--



--
-- TOC entry 3071 (class 0 OID 0)
-- Dependencies: 206
-- Name: tbl_coin_posts_id_seq; Type: SEQUENCE SET; Schema: coins; Owner: -
--

SELECT pg_catalog.setval('coins.tbl_coin_posts_id_seq', 1, false);


--
-- TOC entry 3072 (class 0 OID 0)
-- Dependencies: 204
-- Name: tbl_coin_volume_id_seq; Type: SEQUENCE SET; Schema: coins; Owner: -
--

SELECT pg_catalog.setval('coins.tbl_coin_volume_id_seq', 1, false);


--
-- TOC entry 2916 (class 2606 OID 16445)
-- Name: tbl_coin_now tbl_coin_now_pk; Type: CONSTRAINT; Schema: coins; Owner: -
--

ALTER TABLE ONLY coins.tbl_coin_now
    ADD CONSTRAINT tbl_coin_now_pk PRIMARY KEY (id);


--
-- TOC entry 2918 (class 2606 OID 16449)
-- Name: tbl_coin_now tbl_coin_now_un; Type: CONSTRAINT; Schema: coins; Owner: -
--

ALTER TABLE ONLY coins.tbl_coin_now
    ADD CONSTRAINT tbl_coin_now_un UNIQUE (name);


--
-- TOC entry 2924 (class 2606 OID 16473)
-- Name: tbl_coin_posts tbl_coin_posts_pk; Type: CONSTRAINT; Schema: coins; Owner: -
--

ALTER TABLE ONLY coins.tbl_coin_posts
    ADD CONSTRAINT tbl_coin_posts_pk PRIMARY KEY (id);


--
-- TOC entry 2920 (class 2606 OID 16456)
-- Name: tbl_coin_volume tbl_coin_volume_pk; Type: CONSTRAINT; Schema: coins; Owner: -
--

ALTER TABLE ONLY coins.tbl_coin_volume
    ADD CONSTRAINT tbl_coin_volume_pk PRIMARY KEY (id);


--
-- TOC entry 2922 (class 2606 OID 16466)
-- Name: tbl_coin_volume tbl_coin_volume_un; Type: CONSTRAINT; Schema: coins; Owner: -
--

ALTER TABLE ONLY coins.tbl_coin_volume
    ADD CONSTRAINT tbl_coin_volume_un UNIQUE (volume_date);


--
-- TOC entry 2927 (class 2620 OID 16447)
-- Name: tbl_coin_now tbl_coins_now_but; Type: TRIGGER; Schema: coins; Owner: -
--

CREATE TRIGGER tbl_coins_now_but BEFORE UPDATE ON coins.tbl_coin_now FOR EACH ROW EXECUTE FUNCTION coins.trigger_set_timestamp();


--
-- TOC entry 2928 (class 2620 OID 16458)
-- Name: tbl_coin_volume tbl_coins_volume_but; Type: TRIGGER; Schema: coins; Owner: -
--

CREATE TRIGGER tbl_coins_volume_but BEFORE UPDATE ON coins.tbl_coin_volume FOR EACH ROW EXECUTE FUNCTION coins.trigger_set_timestamp();


--
-- TOC entry 2926 (class 2606 OID 16474)
-- Name: tbl_coin_posts tbl_coin_posts_fk; Type: FK CONSTRAINT; Schema: coins; Owner: -
--

ALTER TABLE ONLY coins.tbl_coin_posts
    ADD CONSTRAINT tbl_coin_posts_fk FOREIGN KEY (coin_uuid) REFERENCES coins.tbl_coin_now(id) ON DELETE CASCADE;


--
-- TOC entry 2925 (class 2606 OID 16459)
-- Name: tbl_coin_volume tbl_coin_volume_fk; Type: FK CONSTRAINT; Schema: coins; Owner: -
--

ALTER TABLE ONLY coins.tbl_coin_volume
    ADD CONSTRAINT tbl_coin_volume_fk FOREIGN KEY (coin_uuid) REFERENCES coins.tbl_coin_now(id);


-- Completed on 2021-07-13 15:23:28 -03

--
-- PostgreSQL database dump complete
--

