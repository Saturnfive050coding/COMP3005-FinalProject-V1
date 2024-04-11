--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)

-- Started on 2024-04-10 19:06:11 EDT

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

--
-- TOC entry 874 (class 1247 OID 16897)
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'male',
    'female'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- TOC entry 895 (class 1247 OID 16969)
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'available',
    'deleted',
    'scheduled',
    'processing'
);


ALTER TYPE public.status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16901)
-- Name: competition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competition (
    competition_name character varying(100) NOT NULL,
    competition_gender public.gender NOT NULL,
    competition_youth boolean,
    season_name character varying(100) NOT NULL,
    match_updated timestamp without time zone,
    match_updated_360 timestamp without time zone,
    match_available timestamp without time zone,
    match_available_360 timestamp without time zone,
    country_name character varying(100),
    competition_international boolean,
    competition_id integer NOT NULL,
    season_id integer NOT NULL
);


ALTER TABLE public.competition OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16916)
-- Name: competition_stage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competition_stage (
    stage_id integer NOT NULL,
    stage_name text NOT NULL
);


ALTER TABLE public.competition_stage OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16827)
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.country (
    country_id integer NOT NULL,
    country_name character varying(100)
);


ALTER TABLE public.country OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17041)
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    event_id text NOT NULL,
    event_index integer NOT NULL,
    event_period integer NOT NULL,
    time_stamp time without time zone DEFAULT '00:00:00'::time without time zone,
    time_minute integer DEFAULT 0,
    time_second integer DEFAULT 0,
    type_id integer NOT NULL,
    posession_team integer,
    pattern_id integer,
    team_id integer,
    player_id integer,
    position_id integer,
    under_pressure boolean,
    off_camera boolean,
    tactic_formation integer,
    related_events text,
    possession integer,
    event_location text,
    "out" boolean,
    counterpress boolean,
    match_id integer,
    duration double precision,
    season_id integer
);


ALTER TABLE public.event OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17110)
-- Name: event_object; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_object (
    object_id integer NOT NULL,
    object_name character varying(100) NOT NULL
);


ALTER TABLE public.event_object OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17116)
-- Name: event_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_type (
    event_type_id integer NOT NULL,
    type_name character varying(100) NOT NULL,
    event_id text NOT NULL,
    outcome_id integer,
    counterpress boolean,
    card_id integer,
    offensive boolean,
    recovery_failure boolean,
    deflection boolean,
    save_block boolean,
    end_location text,
    aerial_won boolean,
    body_part_id integer,
    overrun boolean,
    nutmeg boolean,
    no_touch boolean,
    type_id integer,
    advantage boolean,
    penalty boolean,
    defensive boolean,
    technique_id integer,
    position_id integer,
    early_video_end boolean,
    match_suspended boolean,
    late_video_start boolean,
    recipient_id integer,
    pass_length numeric(5,2),
    angle numeric(5,2),
    height_id integer,
    assisted_shot_id text,
    backheel boolean,
    deflected boolean,
    miscommunication boolean,
    pass_cross boolean,
    cut_back boolean,
    switch boolean,
    shot_assist boolean,
    goal_assist boolean,
    permanent boolean,
    key_pass_id text,
    follows_dribble boolean,
    first_time boolean,
    open_goal boolean,
    statsbomb_xg double precision,
    replacement_id integer,
    left_foot boolean,
    right_foot boolean,
    through_ball boolean,
    one_on_one boolean,
    head boolean,
    outswinging boolean,
    inswinging boolean,
    straight boolean,
    other boolean,
    in_chain boolean,
    punched_out boolean,
    saved_off_target boolean,
    shot_saved_off_target boolean,
    saved_to_post boolean,
    shot_saved_to_post boolean,
    lost_in_play boolean,
    lost_out boolean,
    success_in_play boolean,
    redirect boolean
);


ALTER TABLE public.event_type OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17115)
-- Name: event_type_event_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_type_event_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_type_event_type_id_seq OWNER TO postgres;

--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 230
-- Name: event_type_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_type_event_type_id_seq OWNED BY public.event_type.event_type_id;


--
-- TOC entry 234 (class 1259 OID 17449)
-- Name: event_type_obj; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_type_obj (
    type_id integer NOT NULL,
    type_name text NOT NULL
);


ALTER TABLE public.event_type_obj OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17169)
-- Name: freeze_frame; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.freeze_frame (
    frame_location text,
    player_id integer,
    position_id integer,
    teammate boolean,
    event_id text
);


ALTER TABLE public.freeze_frame OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16975)
-- Name: game_match; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_match (
    match_id integer NOT NULL,
    match_date date NOT NULL,
    kick_off time without time zone NOT NULL,
    competition_id integer NOT NULL,
    home_team_id integer NOT NULL,
    away_team_id integer NOT NULL,
    home_score integer DEFAULT 0,
    away_score integer DEFAULT 0,
    match_status public.status,
    match_status_360 public.status,
    last_updated timestamp without time zone,
    last_updated_360 timestamp without time zone,
    match_week integer NOT NULL,
    competition_stage_id integer NOT NULL,
    referee_id integer,
    stadium_id integer,
    season_id integer
);


ALTER TABLE public.game_match OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16832)
-- Name: lineup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lineup (
    team_name character varying(255),
    season_id integer,
    team_id integer
);


ALTER TABLE public.lineup OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16953)
-- Name: manager; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manager (
    manager_id integer NOT NULL,
    team_id integer NOT NULL,
    manager_name character varying(100) NOT NULL,
    manager_nickname character varying(100),
    manager_dob date,
    country_id integer NOT NULL
);


ALTER TABLE public.manager OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17034)
-- Name: play_pattern; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.play_pattern (
    pattern_id integer NOT NULL,
    pattern_name text NOT NULL
);


ALTER TABLE public.play_pattern OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16837)
-- Name: player; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player (
    player_name character varying(100) NOT NULL,
    player_nickname character varying(100),
    team_id integer NOT NULL,
    country_id integer NOT NULL,
    player_id integer NOT NULL,
    jersey_number integer
);


ALTER TABLE public.player OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16869)
-- Name: player_position; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player_position (
    player_id integer NOT NULL,
    pos integer NOT NULL,
    from_period integer,
    to_period integer,
    start_reason text,
    end_reason text,
    position_id integer NOT NULL,
    from_time character varying(100),
    to_time character varying(100),
    match_id integer
);


ALTER TABLE public.player_position OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17222)
-- Name: player_position_position_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.player_position_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.player_position_position_id_seq OWNER TO postgres;

--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 233
-- Name: player_position_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.player_position_position_id_seq OWNED BY public.player_position.position_id;


--
-- TOC entry 218 (class 1259 OID 16852)
-- Name: position_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.position_type (
    type_id integer NOT NULL,
    type_name character varying(100)
);


ALTER TABLE public.position_type OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16933)
-- Name: referee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referee (
    referee_id integer NOT NULL,
    referree_name character varying(100) NOT NULL,
    country_id integer NOT NULL
);


ALTER TABLE public.referee OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16923)
-- Name: stadium; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stadium (
    stadium_id integer NOT NULL,
    stadium_name character varying(100) NOT NULL,
    country_id integer NOT NULL
);


ALTER TABLE public.stadium OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16943)
-- Name: team; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team (
    team_id integer NOT NULL,
    team_name character varying(100) NOT NULL,
    team_gender public.gender NOT NULL,
    team_group character varying(100),
    country_id integer NOT NULL
);


ALTER TABLE public.team OWNER TO postgres;

--
-- TOC entry 3425 (class 2604 OID 17119)
-- Name: event_type event_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type ALTER COLUMN event_type_id SET DEFAULT nextval('public.event_type_event_type_id_seq'::regclass);


--
-- TOC entry 3419 (class 2604 OID 17223)
-- Name: player_position position_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_position ALTER COLUMN position_id SET DEFAULT nextval('public.player_position_position_id_seq'::regclass);


--
-- TOC entry 3433 (class 2606 OID 17191)
-- Name: competition competition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competition
    ADD CONSTRAINT competition_pkey PRIMARY KEY (season_id);


--
-- TOC entry 3435 (class 2606 OID 16922)
-- Name: competition_stage competition_stage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competition_stage
    ADD CONSTRAINT competition_stage_pkey PRIMARY KEY (stage_id);


--
-- TOC entry 3427 (class 2606 OID 16831)
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- TOC entry 3451 (class 2606 OID 17114)
-- Name: event_object event_object_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_object
    ADD CONSTRAINT event_object_pkey PRIMARY KEY (object_id);


--
-- TOC entry 3449 (class 2606 OID 17050)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (event_id);


--
-- TOC entry 3455 (class 2606 OID 17455)
-- Name: event_type_obj event_type_obj_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type_obj
    ADD CONSTRAINT event_type_obj_pkey PRIMARY KEY (type_id);


--
-- TOC entry 3453 (class 2606 OID 17123)
-- Name: event_type event_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT event_type_pkey PRIMARY KEY (event_type_id);


--
-- TOC entry 3445 (class 2606 OID 16981)
-- Name: game_match game_match_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_match
    ADD CONSTRAINT game_match_pkey PRIMARY KEY (match_id);


--
-- TOC entry 3443 (class 2606 OID 16957)
-- Name: manager manager_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT manager_pkey PRIMARY KEY (manager_id);


--
-- TOC entry 3447 (class 2606 OID 17040)
-- Name: play_pattern play_pattern_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_pattern
    ADD CONSTRAINT play_pattern_pkey PRIMARY KEY (pattern_id);


--
-- TOC entry 3431 (class 2606 OID 17225)
-- Name: player_position player_position_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_position
    ADD CONSTRAINT player_position_pkey PRIMARY KEY (position_id);


--
-- TOC entry 3429 (class 2606 OID 16856)
-- Name: position_type position_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.position_type
    ADD CONSTRAINT position_type_pkey PRIMARY KEY (type_id);


--
-- TOC entry 3439 (class 2606 OID 16937)
-- Name: referee referee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referee
    ADD CONSTRAINT referee_pkey PRIMARY KEY (referee_id);


--
-- TOC entry 3437 (class 2606 OID 16927)
-- Name: stadium stadium_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadium
    ADD CONSTRAINT stadium_pkey PRIMARY KEY (stadium_id);


--
-- TOC entry 3441 (class 2606 OID 16947)
-- Name: team team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (team_id);


--
-- TOC entry 3463 (class 2606 OID 16992)
-- Name: game_match fk_away_team; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_match
    ADD CONSTRAINT fk_away_team FOREIGN KEY (away_team_id) REFERENCES public.team(team_id);


--
-- TOC entry 3473 (class 2606 OID 17134)
-- Name: event_type fk_body_part; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_body_part FOREIGN KEY (body_part_id) REFERENCES public.event_object(object_id);


--
-- TOC entry 3474 (class 2606 OID 17129)
-- Name: event_type fk_card; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_card FOREIGN KEY (card_id) REFERENCES public.event_object(object_id);


--
-- TOC entry 3464 (class 2606 OID 17002)
-- Name: game_match fk_comp_stage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_match
    ADD CONSTRAINT fk_comp_stage FOREIGN KEY (competition_stage_id) REFERENCES public.competition_stage(stage_id);


--
-- TOC entry 3456 (class 2606 OID 16847)
-- Name: player fk_country; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player
    ADD CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES public.country(country_id);


--
-- TOC entry 3458 (class 2606 OID 16928)
-- Name: stadium fk_country; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadium
    ADD CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES public.country(country_id);


--
-- TOC entry 3459 (class 2606 OID 16938)
-- Name: referee fk_country; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referee
    ADD CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES public.country(country_id);


--
-- TOC entry 3460 (class 2606 OID 16948)
-- Name: team fk_country; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES public.country(country_id);


--
-- TOC entry 3461 (class 2606 OID 16958)
-- Name: manager fk_country; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES public.country(country_id);


--
-- TOC entry 3475 (class 2606 OID 17159)
-- Name: event_type fk_height; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_height FOREIGN KEY (height_id) REFERENCES public.event_object(object_id);


--
-- TOC entry 3465 (class 2606 OID 16987)
-- Name: game_match fk_home_team; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_match
    ADD CONSTRAINT fk_home_team FOREIGN KEY (home_team_id) REFERENCES public.team(team_id);


--
-- TOC entry 3476 (class 2606 OID 17164)
-- Name: event_type fk_key_pass; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_key_pass FOREIGN KEY (key_pass_id) REFERENCES public.event(event_id);


--
-- TOC entry 3468 (class 2606 OID 17717)
-- Name: event fk_match; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_match FOREIGN KEY (match_id) REFERENCES public.game_match(match_id);


--
-- TOC entry 3477 (class 2606 OID 17124)
-- Name: event_type fk_outcome; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_outcome FOREIGN KEY (outcome_id) REFERENCES public.event_object(object_id);


--
-- TOC entry 3469 (class 2606 OID 17061)
-- Name: event fk_pattern; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_pattern FOREIGN KEY (pattern_id) REFERENCES public.play_pattern(pattern_id);


--
-- TOC entry 3470 (class 2606 OID 17056)
-- Name: event fk_posession_team; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_posession_team FOREIGN KEY (posession_team) REFERENCES public.team(team_id);


--
-- TOC entry 3471 (class 2606 OID 17232)
-- Name: event fk_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_position FOREIGN KEY (position_id) REFERENCES public.position_type(type_id);


--
-- TOC entry 3481 (class 2606 OID 17242)
-- Name: freeze_frame fk_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.freeze_frame
    ADD CONSTRAINT fk_position FOREIGN KEY (position_id) REFERENCES public.position_type(type_id);


--
-- TOC entry 3478 (class 2606 OID 17505)
-- Name: event_type fk_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_position FOREIGN KEY (position_id) REFERENCES public.event_object(object_id);


--
-- TOC entry 3457 (class 2606 OID 16881)
-- Name: player_position fk_postype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.player_position
    ADD CONSTRAINT fk_postype FOREIGN KEY (pos) REFERENCES public.position_type(type_id);


--
-- TOC entry 3466 (class 2606 OID 17289)
-- Name: game_match fk_referee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_match
    ADD CONSTRAINT fk_referee FOREIGN KEY (referee_id) REFERENCES public.referee(referee_id);


--
-- TOC entry 3467 (class 2606 OID 17339)
-- Name: game_match fk_stadium; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_match
    ADD CONSTRAINT fk_stadium FOREIGN KEY (stadium_id) REFERENCES public.stadium(stadium_id);


--
-- TOC entry 3462 (class 2606 OID 16963)
-- Name: manager fk_team; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager
    ADD CONSTRAINT fk_team FOREIGN KEY (team_id) REFERENCES public.team(team_id);


--
-- TOC entry 3472 (class 2606 OID 17066)
-- Name: event fk_team; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT fk_team FOREIGN KEY (team_id) REFERENCES public.team(team_id);


--
-- TOC entry 3479 (class 2606 OID 17149)
-- Name: event_type fk_technique; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_technique FOREIGN KEY (technique_id) REFERENCES public.event_object(object_id);


--
-- TOC entry 3480 (class 2606 OID 17139)
-- Name: event_type fk_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_type
    ADD CONSTRAINT fk_type FOREIGN KEY (type_id) REFERENCES public.event_object(object_id);



ALTER TABLE ONLY public.game_match 
	ADD CONSTRAINT fk_season FOREIGN KEY (season_id) REFERENCES public.competition (season_id);

-- Completed on 2024-04-10 19:06:11 EDT

--
-- PostgreSQL database dump complete
--

