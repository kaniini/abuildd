--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: job_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE job_status_enum AS ENUM (
    'unbuilt',
    'success',
    'failure'
);


ALTER TYPE job_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: host; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE host (
    host_id integer NOT NULL,
    name character varying(255),
    arch character varying(255)
);


ALTER TABLE host OWNER TO postgres;

--
-- Name: host_host_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE host_host_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE host_host_id_seq OWNER TO postgres;

--
-- Name: host_host_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE host_host_id_seq OWNED BY host.host_id;


--
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE job (
    job_id integer NOT NULL,
    status job_status_enum DEFAULT 'unbuilt'::job_status_enum NOT NULL,
    target character varying(255) NOT NULL,
    version character varying(255) NOT NULL,
    host character varying(255) NOT NULL,
    arch character varying(255) NOT NULL,
    branch character varying(255) DEFAULT 'master'::character varying NOT NULL,
    maintainer character varying(255) NOT NULL
);


ALTER TABLE job OWNER TO postgres;

--
-- Name: job_artifact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE job_artifact (
    job_artifact_id integer NOT NULL,
    job_id integer,
    filename character varying(4096)
);


ALTER TABLE job_artifact OWNER TO postgres;

--
-- Name: job_artifact_job_artifact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE job_artifact_job_artifact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_artifact_job_artifact_id_seq OWNER TO postgres;

--
-- Name: job_artifact_job_artifact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE job_artifact_job_artifact_id_seq OWNED BY job_artifact.job_artifact_id;


--
-- Name: job_dependency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE job_dependency (
    job_dependency_id integer NOT NULL,
    job_id integer,
    dependent_id integer
);


ALTER TABLE job_dependency OWNER TO postgres;

--
-- Name: job_dependency_job_dependency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE job_dependency_job_dependency_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_dependency_job_dependency_id_seq OWNER TO postgres;

--
-- Name: job_dependency_job_dependency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE job_dependency_job_dependency_id_seq OWNED BY job_dependency.job_dependency_id;


--
-- Name: job_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE job_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_job_id_seq OWNER TO postgres;

--
-- Name: job_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE job_job_id_seq OWNED BY job.job_id;


--
-- Name: host host_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY host ALTER COLUMN host_id SET DEFAULT nextval('host_host_id_seq'::regclass);


--
-- Name: job job_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job ALTER COLUMN job_id SET DEFAULT nextval('job_job_id_seq'::regclass);


--
-- Name: job_artifact job_artifact_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job_artifact ALTER COLUMN job_artifact_id SET DEFAULT nextval('job_artifact_job_artifact_id_seq'::regclass);


--
-- Name: job_dependency job_dependency_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job_dependency ALTER COLUMN job_dependency_id SET DEFAULT nextval('job_dependency_job_dependency_id_seq'::regclass);


--
-- Name: host host_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY host
    ADD CONSTRAINT host_pkey PRIMARY KEY (host_id);


--
-- Name: job_artifact job_artifact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job_artifact
    ADD CONSTRAINT job_artifact_pkey PRIMARY KEY (job_artifact_id);


--
-- Name: job_dependency job_dependency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job_dependency
    ADD CONSTRAINT job_dependency_pkey PRIMARY KEY (job_dependency_id);


--
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- Name: job_artifact job_artifact_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job_artifact
    ADD CONSTRAINT job_artifact_job_id_fkey FOREIGN KEY (job_id) REFERENCES job(job_id);


--
-- Name: job_dependency job_dependency_dependent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job_dependency
    ADD CONSTRAINT job_dependency_dependent_id_fkey FOREIGN KEY (dependent_id) REFERENCES job(job_id);


--
-- Name: job_dependency job_dependency_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY job_dependency
    ADD CONSTRAINT job_dependency_job_id_fkey FOREIGN KEY (job_id) REFERENCES job(job_id);


--
-- PostgreSQL database dump complete
--

