--
-- PostgreSQL database dump
--

-- Dumped from database version 12.15 (Ubuntu 12.15-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.15 (Ubuntu 12.15-0ubuntu0.20.04.1)

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
-- Name: festivals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.festivals (
    displayname character varying(255) NOT NULL,
    festival integer NOT NULL,
    centre_lat real,
    centre_long real,
    height real,
    width real
);


ALTER TABLE public.festivals OWNER TO postgres;

--
-- Name: stages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stages (
    id integer NOT NULL,
    festival integer,
    stage character varying(255),
    lat real,
    long real
);


ALTER TABLE public.stages OWNER TO postgres;

--
-- Name: toilets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toilets (
    id integer NOT NULL,
    festival integer,
    lat real,
    long real
);


ALTER TABLE public.toilets OWNER TO postgres;

--
-- Name: waters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waters (
    id integer NOT NULL,
    festival integer,
    lat real,
    long real
);


ALTER TABLE public.waters OWNER TO postgres;

--
-- Data for Name: festivals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.festivals (displayname, festival, centre_lat, centre_long, height, width) FROM stdin;
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stages (id, festival, stage, lat, long) FROM stdin;
\.


--
-- Data for Name: toilets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toilets (id, festival, lat, long) FROM stdin;
\.


--
-- Data for Name: waters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waters (id, festival, lat, long) FROM stdin;
\.


--
-- Name: festivals festival; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.festivals
    ADD CONSTRAINT festival PRIMARY KEY (festival);


--
-- Name: stages stagesid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stagesid PRIMARY KEY (id);


--
-- Name: toilets toiletsid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT toiletsid PRIMARY KEY (id);


--
-- Name: waters watersid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waters
    ADD CONSTRAINT watersid PRIMARY KEY (id);


--
-- Name: fki_stagesfest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_stagesfest ON public.stages USING btree (festival);


--
-- Name: fki_toiletfest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_toiletfest ON public.toilets USING btree (festival);


--
-- Name: fki_watersfest; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_watersfest ON public.waters USING btree (festival);


--
-- Name: stages stagesfest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stagesfest FOREIGN KEY (festival) REFERENCES public.festivals(festival) NOT VALID;


--
-- Name: toilets toiletfest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toilets
    ADD CONSTRAINT toiletfest FOREIGN KEY (festival) REFERENCES public.festivals(festival) NOT VALID;


--
-- Name: waters watersfest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waters
    ADD CONSTRAINT watersfest FOREIGN KEY (festival) REFERENCES public.festivals(festival) NOT VALID;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO ios;


--
-- Name: TABLE festivals; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.festivals TO ios;


--
-- Name: TABLE stages; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.stages TO ios;


--
-- Name: TABLE toilets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.toilets TO ios;


--
-- Name: TABLE waters; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.waters TO ios;


--
-- PostgreSQL database dump complete
--

