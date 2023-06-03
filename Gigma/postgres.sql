--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8 (Homebrew)
-- Dumped by pg_dump version 14.8 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: festivals; Type: TABLE; Schema: public; Owner: alice
--

CREATE TABLE public.festivals (
    displayname character varying(255) NOT NULL,
    festival integer NOT NULL,
    centre_lat real,
    centre_long real,
    height real,
    width real
);


ALTER TABLE public.festivals OWNER TO alice;

--
-- Name: stages; Type: TABLE; Schema: public; Owner: alice
--

CREATE TABLE public.stages (
    id integer NOT NULL,
    festival integer,
    stage character varying(255),
    lat real,
    long real
);


ALTER TABLE public.stages OWNER TO alice;

--
-- Name: toilets; Type: TABLE; Schema: public; Owner: alice
--

CREATE TABLE public.toilets (
    id integer NOT NULL,
    festival integer,
    lat real,
    long real
);


ALTER TABLE public.toilets OWNER TO alice;

--
-- Name: waters; Type: TABLE; Schema: public; Owner: alice
--

CREATE TABLE public.waters (
    id integer NOT NULL,
    festival integer,
    lat real,
    long real
);


ALTER TABLE public.waters OWNER TO alice;

--
-- Data for Name: festivals; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public.festivals (displayname, festival, centre_lat, centre_long, height, width) FROM stdin;
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public.stages (id, festival, stage, lat, long) FROM stdin;
\.


--
-- Data for Name: toilets; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public.toilets (id, festival, lat, long) FROM stdin;
\.


--
-- Data for Name: waters; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public.waters (id, festival, lat, long) FROM stdin;
\.


--
-- Name: festivals festival; Type: CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public.festivals
    ADD CONSTRAINT festival PRIMARY KEY (festival);


--
-- Name: stages stagesid; Type: CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stagesid PRIMARY KEY (id);


--
-- Name: toilets toiletsid; Type: CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT toiletsid PRIMARY KEY (id);


--
-- Name: waters watersid; Type: CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public.waters
    ADD CONSTRAINT watersid PRIMARY KEY (id);


--
-- Name: fki_stagesfest; Type: INDEX; Schema: public; Owner: alice
--

CREATE INDEX fki_stagesfest ON public.stages USING btree (festival);


--
-- Name: fki_toiletfest; Type: INDEX; Schema: public; Owner: alice
--

CREATE INDEX fki_toiletfest ON public.toilets USING btree (festival);


--
-- Name: fki_watersfest; Type: INDEX; Schema: public; Owner: alice
--

CREATE INDEX fki_watersfest ON public.waters USING btree (festival);


--
-- Name: stages stagesfest; Type: FK CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stagesfest FOREIGN KEY (festival) REFERENCES public.festivals(festival) NOT VALID;


--
-- Name: toilets toiletfest; Type: FK CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT toiletfest FOREIGN KEY (festival) REFERENCES public.festivals(festival) NOT VALID;


--
-- Name: waters watersfest; Type: FK CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public.waters
    ADD CONSTRAINT watersfest FOREIGN KEY (festival) REFERENCES public.festivals(festival) NOT VALID;


--
-- PostgreSQL database dump complete
--

