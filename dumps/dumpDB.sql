--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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
-- Name: cuisine_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.cuisine_type AS ENUM (
    'Italian',
    'French',
    'Japanese',
    'Russian',
    'American',
    'Derivative'
);


ALTER TYPE public.cuisine_type OWNER TO postgres;

--
-- Name: payment_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_type AS ENUM (
    'credit_card',
    'paypal',
    'cash'
);


ALTER TYPE public.payment_type OWNER TO postgres;

--
-- Name: reservation_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.reservation_status AS ENUM (
    'pending',
    'cancelled',
    'completed'
);


ALTER TYPE public.reservation_status OWNER TO postgres;

--
-- Name: seating_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.seating_status AS ENUM (
    'reserved',
    'free',
    'not_available'
);


ALTER TYPE public.seating_status OWNER TO postgres;

--
-- Name: check_cuisine_type_exists(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_cuisine_type_exists() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.cuisine_type NOT IN ('Italian', 'French', 'Japanese', 'Russian', 'American', 'Derivative') THEN
        RAISE EXCEPTION '“Є § ­­®Ј® вЁЇ  Єге­Ё ­Ґ бгйҐбвўгҐв. Џ®¦ «г©бв , Ґб«Ё ўл ўЁ¤ЁвҐ нв® б®®ЎйҐ­ЁҐ в® ўлЎҐаЁвҐ вЁЇ Єге­Ё "Derivative" (Џа®Ё§ў®«м­л©).';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_cuisine_type_exists() OWNER TO postgres;

--
-- Name: delete_customer(uuid); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_customer(IN p_customer_id uuid)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM reservations WHERE id_customer = p_customer_id;
    DELETE FROM customer_reviews WHERE id_customer = p_customer_id;
    DELETE FROM customer WHERE id_customer = p_customer_id;
END;
$$;


ALTER PROCEDURE public.delete_customer(IN p_customer_id uuid) OWNER TO postgres;

--
-- Name: delete_restaurant(uuid); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_restaurant(IN p_restaurant_id uuid)
    LANGUAGE plpgsql
    AS $$
DECLARE
    reservation_count INT;
BEGIN
    SELECT COUNT(*) INTO reservation_count
    FROM reservations
    WHERE id_seating IN (SELECT id_seating FROM seating WHERE id_restaurant = p_restaurant_id);

    IF reservation_count > 0 THEN
        RAISE EXCEPTION 'Невозможно удалить данный ресторан, пока имеются бронирования в нём';
    ELSE
        DELETE FROM reservations WHERE id_seating IN (SELECT id_seating FROM seating WHERE id_restaurant = p_restaurant_id);
        DELETE FROM seating WHERE id_restaurant = p_restaurant_id;
        DELETE FROM restaurant_staff WHERE id_restaurant = p_restaurant_id;
        DELETE FROM restaurant_special_offers WHERE id_restaurant = p_restaurant_id;
        DELETE FROM customer_reviews WHERE id_restaurant = p_restaurant_id;
        DELETE FROM restaurant WHERE id_restaurant = p_restaurant_id;
    END IF;
END;
$$;


ALTER PROCEDURE public.delete_restaurant(IN p_restaurant_id uuid) OWNER TO postgres;

--
-- Name: delete_review_and_reservation(uuid); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_review_and_reservation(IN p_id_review uuid)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM reservations WHERE id_customer IN (SELECT id_customer FROM customer_reviews WHERE id_review = p_id_review);
    DELETE FROM customer_reviews WHERE id_review = p_id_review;
END;
$$;


ALTER PROCEDURE public.delete_review_and_reservation(IN p_id_review uuid) OWNER TO postgres;

--
-- Name: update_address_and_name_restaurant(uuid, character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_address_and_name_restaurant(IN p_id_address uuid, IN p_name character varying, IN p_country character varying, IN p_state character varying, IN p_city character varying, IN p_street character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE restaurant
    SET name = p_name
    WHERE id_address = p_id_address;

    UPDATE restaurant_address
    SET country = p_country,
    state = p_state,
    city = p_city,
    street = p_street
    WHERE id_address = p_id_address;
END
$$;


ALTER PROCEDURE public.update_address_and_name_restaurant(IN p_id_address uuid, IN p_name character varying, IN p_country character varying, IN p_state character varying, IN p_city character varying, IN p_street character varying) OWNER TO postgres;

--
-- Name: update_cuisine_and_additional_info(uuid, character varying, public.cuisine_type); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_cuisine_and_additional_info(IN p_id_cuisine uuid, IN p_additional_info character varying, IN p_cuisine_type public.cuisine_type)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE cuisine
    SET cuisine_type = p_cuisine_type
    WHERE id_cuisine = p_id_cuisine;

    UPDATE restaurant_details
    SET additional_info = p_additional_info
    WHERE id_cuisine = p_id_cuisine;
END
$$;


ALTER PROCEDURE public.update_cuisine_and_additional_info(IN p_id_cuisine uuid, IN p_additional_info character varying, IN p_cuisine_type public.cuisine_type) OWNER TO postgres;

--
-- Name: update_restaurant_full_info(uuid, character varying, character varying, character varying, character varying, character varying, character varying, time without time zone, time without time zone, public.cuisine_type, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_restaurant_full_info(IN p_id_restaurant uuid, IN p_name character varying, IN p_restaurant_phone character varying, IN p_country character varying, IN p_state character varying, IN p_city character varying, IN p_street character varying, IN p_opening_time time without time zone, IN p_closing_time time without time zone, IN p_cuisine_type public.cuisine_type, IN p_additional_info character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE restaurant
    SET name = p_name,
    restaurant_phone = p_restaurant_phone
    WHERE id_restaurant = p_id_restaurant;
    
    UPDATE restaurant_address
    SET country = p_country,
    state = p_state,
    city = p_city,
    street = p_street
    WHERE id_address = (SELECT id_address FROM restaurant WHERE id_restaurant = p_id_restaurant);
    
    UPDATE working_hours
    SET opening_time = p_opening_time,
    closing_time = p_closing_time
    WHERE id_working_hours = (SELECT id_working_hours FROM restaurant WHERE id_restaurant = p_id_restaurant);
    
    UPDATE cuisine
    SET cuisine_type = p_cuisine_type
    WHERE id_cuisine = (SELECT id_cuisine FROM restaurant_details WHERE id_details = (SELECT id_details FROM restaurant WHERE id_restaurant = p_id_restaurant));
    
    UPDATE restaurant_details
    SET additional_info = p_additional_info
    WHERE id_details = (SELECT id_details FROM restaurant WHERE id_restaurant = p_id_restaurant);
END
$$;


ALTER PROCEDURE public.update_restaurant_full_info(IN p_id_restaurant uuid, IN p_name character varying, IN p_restaurant_phone character varying, IN p_country character varying, IN p_state character varying, IN p_city character varying, IN p_street character varying, IN p_opening_time time without time zone, IN p_closing_time time without time zone, IN p_cuisine_type public.cuisine_type, IN p_additional_info character varying) OWNER TO postgres;

--
-- Name: update_review(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_review() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_review() OWNER TO postgres;

--
-- Name: validate_phone_number(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_phone_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN
    IF NEW.restaurant_phone ~ '^[0-9]{1,24}$' THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Ќ®¬Ґа вҐ«Ґд®­  ¤®«¦Ґ­ б®¤Ґа¦ вм в®«мЄ® жЁдал Ё ­Ґ ЇаҐўли вм 24 бЁ¬ў®« .';
    END IF;
END;
$_$;


ALTER FUNCTION public.validate_phone_number() OWNER TO postgres;

--
-- Name: validate_working_hours(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_working_hours() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.closing_time < NEW.opening_time THEN
        RAISE EXCEPTION 'Время закрытия работы ресторана не может быть раньше чем начало работы ресторана';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_working_hours() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cuisine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuisine (
    id_cuisine uuid NOT NULL,
    cuisine_type public.cuisine_type NOT NULL
);


ALTER TABLE public.cuisine OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id_customer uuid NOT NULL,
    name_customer character varying(128) NOT NULL,
    payment_type public.payment_type NOT NULL,
    customer_phone character varying(24) NOT NULL,
    email character varying(64),
    CONSTRAINT customer_customer_phone_check CHECK ((length((customer_phone)::text) <= 12))
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_reviews (
    id_review uuid NOT NULL,
    id_customer uuid NOT NULL,
    id_restaurant uuid NOT NULL,
    rating integer NOT NULL,
    review_text character varying(512),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone,
    CONSTRAINT customer_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.customer_reviews OWNER TO postgres;

--
-- Name: reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservations (
    id_reservation uuid NOT NULL,
    id_customer uuid NOT NULL,
    id_seating uuid NOT NULL,
    reservation_status public.reservation_status NOT NULL,
    clarification character varying(256),
    reservation_date date,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.reservations OWNER TO postgres;

--
-- Name: restaurant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurant (
    id_restaurant uuid NOT NULL,
    id_working_hours uuid NOT NULL,
    id_details uuid NOT NULL,
    id_address uuid NOT NULL,
    name character varying(64) NOT NULL,
    restaurant_phone character varying(24) NOT NULL
);


ALTER TABLE public.restaurant OWNER TO postgres;

--
-- Name: restaurant_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurant_address (
    id_address uuid NOT NULL,
    country character varying(128) NOT NULL,
    state character varying(128),
    city character varying(128) NOT NULL,
    street character varying(128) NOT NULL
);


ALTER TABLE public.restaurant_address OWNER TO postgres;

--
-- Name: restaurant_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurant_details (
    id_details uuid NOT NULL,
    id_cuisine uuid NOT NULL,
    social_media_links jsonb,
    additional_info character varying(512)
);


ALTER TABLE public.restaurant_details OWNER TO postgres;

--
-- Name: restaurant_special_offers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurant_special_offers (
    id_offer uuid NOT NULL,
    id_restaurant uuid NOT NULL,
    offer_name character varying(64) NOT NULL,
    description character varying(256),
    start_offer date NOT NULL,
    end_offer date NOT NULL
);


ALTER TABLE public.restaurant_special_offers OWNER TO postgres;

--
-- Name: restaurant_staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurant_staff (
    id_staff uuid NOT NULL,
    id_restaurant uuid NOT NULL,
    name_staff character varying(128) NOT NULL,
    "position" character varying(64),
    contact_number character varying(24)
);


ALTER TABLE public.restaurant_staff OWNER TO postgres;

--
-- Name: seating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seating (
    id_seating uuid NOT NULL,
    id_restaurant uuid NOT NULL,
    seating_status public.seating_status NOT NULL,
    capacity integer DEFAULT 1 NOT NULL,
    CONSTRAINT seating_capacity_check CHECK ((capacity > 0))
);


ALTER TABLE public.seating OWNER TO postgres;

--
-- Name: working_hours; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.working_hours (
    id_working_hours uuid NOT NULL,
    opening_time time without time zone NOT NULL,
    closing_time time without time zone NOT NULL
);


ALTER TABLE public.working_hours OWNER TO postgres;

--
-- Data for Name: cuisine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuisine (id_cuisine, cuisine_type) FROM stdin;
2855ad43-9422-4283-bd00-cb3d452c0e8a	Japanese
e611f5cd-a124-483a-a76a-591a3bfdd2b1	Derivative
a35fadf9-94ac-43e5-b303-fa6996c590de	American
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id_customer, name_customer, payment_type, customer_phone, email) FROM stdin;
47a59dfd-9d2d-4d68-ae18-3d853c99294f	Jacques Haley	credit_card	+75964090189	Jacques_Haley@yahoo.com
44413b44-a362-48dc-a433-86275da7a7ba	Emil Pfeffer	cash	+79049672686	Emil_Pfeffer20@hotmail.com
904eab89-87cb-4829-95c9-b7e55c68c523	Meda Baumbach	paypal	+73188156515	Meda_Baumbach67@yahoo.com
432f05e7-dbdb-4d28-baee-f33feeb1c3eb	Lysanne Schimmel	cash	+76380033763	Lysanne_Schimmel85@yahoo.com
da3bc715-589e-4752-86ea-096be354093f	Darrel Hilll	paypal	+76119985508	Darrel.Hilll@gmail.com
5ca6cf61-5c45-4f9b-9781-ffc7a040e3be	Garry Murray	cash	+76734244637	Garry_Murray@yahoo.com
baeac644-4aec-42b1-805d-0323c366adc3	Alivia Schimmel-Morissette	credit_card	+74678521001	Alivia_Schimmel-Morissette17@gmail.com
b7829c34-636f-4442-80d4-c0a85810f137	Willa Cormier	credit_card	+71568849034	Willa_Cormier21@yahoo.com
8af374f7-7738-4939-b7f5-9a348d282d59	Francisca Kassulke	cash	+73502421276	Francisca.Kassulke55@yahoo.com
86cfe2b1-a946-43f0-8e77-d075a13d9972	Emilie Parisian	cash	+72295195144	Emilie.Parisian@yahoo.com
3f45e4d6-e125-4a85-a355-509e70284dae	Abbie Pagac	paypal	+74139013129	Abbie.Pagac22@gmail.com
91d0795c-0792-4f93-b6b8-9fa3c02b21a4	Jamaal Blanda	cash	+77454437282	Jamaal_Blanda@gmail.com
75bea434-86f5-4c88-aa40-15b894f0f163	Meghan Berge	cash	+78068828002	Meghan.Berge@hotmail.com
0bbe17e8-62a5-4c77-a93f-ed04db71d9cc	Edythe Collins	cash	+73000517822	Edythe_Collins67@gmail.com
355a9829-a8b5-4d88-baa8-9fa627730412	Larissa Berge-Hickle	credit_card	+75495247725	Larissa.Berge-Hickle47@yahoo.com
1efb7727-044a-4d7c-96f0-37383a47c78f	Maurice Cole	paypal	+76076121131	Maurice_Cole0@hotmail.com
52a42ac5-0a32-40fd-9d50-b426297b1cd0	Trinity Ruecker	cash	+73693726022	Trinity.Ruecker13@yahoo.com
e2c98423-7de1-4daa-a317-49eaefe71a6d	Ramon Buckridge	cash	+74560134967	Ramon_Buckridge@gmail.com
f45a4877-81fb-4d83-a87f-fe3ea1f56848	Adrien Morissette	cash	+77309724391	Adrien_Morissette@yahoo.com
2c7092c0-19a2-46d3-8891-78e518c1dc9e	Allene Corwin	cash	+78526946850	Allene_Corwin@gmail.com
04b7023e-9641-41f5-a4fb-47c4ee7a891a	Angeline Cummerata	paypal	+70565551935	Angeline_Cummerata@gmail.com
c1084767-3e35-4bf7-977c-7800c4e3774a	Janick Waters	credit_card	+73640682320	Janick.Waters57@gmail.com
1650ea44-a818-4aa8-82ca-6211b8dcd342	Glennie Harvey	paypal	+73154941183	Glennie_Harvey@yahoo.com
340e4c51-3d02-4ce3-8ca8-a87a883412f8	Rogers Roberts	cash	+75637510475	Rogers_Roberts@hotmail.com
8fe7f571-de48-4463-8948-b49ebe51b225	Ward Hagenes	cash	+79336374879	Ward_Hagenes@yahoo.com
68639a14-05af-420d-af99-80053106aaf2	Juana Terry	paypal	+78870432667	Juana.Terry@hotmail.com
9c9b65a9-878a-47ee-baf5-f67e09cb5646	Glenna Bahringer	cash	+75938983152	Glenna_Bahringer@yahoo.com
7bbed02c-8978-4d69-8f09-61580e316e4d	Mortimer Ebert	cash	+73454519220	Mortimer_Ebert@gmail.com
8a464ed5-1243-4bb5-afe7-6c07252b3b58	Scarlett Nikolaus	credit_card	+77271759784	Scarlett.Nikolaus38@hotmail.com
fedb13dc-5422-4937-bfd3-4d75d1dde9f1	Violette Armstrong	paypal	+75890059627	Violette_Armstrong86@gmail.com
5bbd7e6b-ce25-4155-8fb0-9614c1d7ddcf	Lola Bauch	credit_card	+72800340083	Lola.Bauch@yahoo.com
193b667d-5f89-465b-9428-5a5caa2dfeaf	Graham Kshlerin	paypal	+70525875454	Graham_Kshlerin24@hotmail.com
6d0bd165-1e34-4948-bc1e-bf336d3bcd9e	Patrick Wuckert	credit_card	+79685952540	Patrick.Wuckert@yahoo.com
91ef4c58-9d4a-4c19-bd06-71db28c59d4e	Linnie Cruickshank	paypal	+70357862359	Linnie.Cruickshank@yahoo.com
50d8a608-c64a-4774-a746-2df0bb062307	Saul Witting	paypal	+77363311609	Saul_Witting39@hotmail.com
d5f82478-e421-4227-b778-3d40ee26f5b7	Eulalia Borer	paypal	+72247467194	Eulalia.Borer23@yahoo.com
567b4c10-c5ec-46e1-a078-efdf41d7b763	Micheal Pagac	credit_card	+76068374755	Micheal_Pagac@hotmail.com
e95c44e3-09ed-4163-bdfa-1cf9194d054d	Susan Jenkins	credit_card	+75655756463	Susan.Jenkins73@hotmail.com
88d6c654-0e9e-4a35-9caf-c3a67c056f8a	Alycia Streich	credit_card	+74687342993	Alycia.Streich27@hotmail.com
\.


--
-- Data for Name: customer_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_reviews (id_review, id_customer, id_restaurant, rating, review_text, created_at, updated_at) FROM stdin;
048bd1a0-f72b-4893-b515-a12ef866f994	193b667d-5f89-465b-9428-5a5caa2dfeaf	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	3	Curso curo vitium deorsum blandior vobis conor vallum tenus aspicio.\nAggero ratione sumptus advenio adfectus ea.	2024-03-16 17:44:52.518715	\N
5deb9a56-542b-41c3-8c65-66e02e4fac22	86cfe2b1-a946-43f0-8e77-d075a13d9972	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	3	Appello esse trepide cornu.	2024-03-16 17:44:52.518715	\N
ab5d0ac5-ab41-4c63-a385-eca1ba88b038	baeac644-4aec-42b1-805d-0323c366adc3	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	2	Dapifer modi delinquo ambulo casus coaegresco aedificium spoliatio.\nCaste adhuc tempora dedico.	2024-03-16 17:44:52.518715	\N
317dc1b9-e977-42fa-9217-c63fd009241d	432f05e7-dbdb-4d28-baee-f33feeb1c3eb	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	2	Nulla cado adulatio cibus.\nCrustulum peccatus bellicus caecus auxilium quam asperiores dolores.	2024-03-16 17:44:52.518715	\N
4997600e-57e2-448c-b3e0-80082b447631	c1084767-3e35-4bf7-977c-7800c4e3774a	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	1	Corpus viduo brevis ipsum alius basium culpo collum vorago delectus.\nDecumbo corroboro arbitro hic annus alveus summopere.\nDeripio comburo comparo approbo bis sursum aliqua pel.\nVicissitudo ventito deprimo accedo defetiscor vulgo dens voluptates conatus.	2024-03-16 17:44:52.518715	\N
ef03b3e3-710b-404f-8529-cbbe3972913c	6d0bd165-1e34-4948-bc1e-bf336d3bcd9e	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	4	Animi totidem inflammatio amet ancilla appello adeptio.\nTempora depraedor custodia demum aeneus.\nClam ulciscor cotidie necessitatibus damnatio bis utique amiculum.\nSumo campana bos.	2024-03-16 17:44:52.518715	\N
90a7bcce-7d85-4fef-a0cc-dcbd3ea3ff4b	3f45e4d6-e125-4a85-a355-509e70284dae	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	5	Arcesso celer supra tredecim a succurro sollers auditor solvo.\nCupiditate confero velum.\nIpsum ipsa ducimus subnecto bestia recusandae ambulo audentia.	2024-03-16 17:44:52.51174	\N
4e70e58a-a373-4553-980e-59ffb26795bb	6d0bd165-1e34-4948-bc1e-bf336d3bcd9e	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	3	Virga supplanto appello votum amitto.\nCito ultio animadverto doloribus spargo agnosco tristis benevolentia eveniet caries.\nTardus vox sursum venustas veniam subnecto sum.\nCeno conforto auctus thermae crur aurum.	2024-03-16 17:44:52.518715	\N
0cf947d7-7c36-4444-a803-7659fb1e18b2	5ca6cf61-5c45-4f9b-9781-ffc7a040e3be	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	4	Nemo curo at aliquam catena speculum amiculum trucido.\nClarus condico infit theatrum.	2024-03-16 17:44:52.518715	\N
a32da933-fc35-4417-b07a-82e846be789b	340e4c51-3d02-4ce3-8ca8-a87a883412f8	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	3	Sortitus pel depono ab aequus minima basium.	2024-03-16 17:44:52.51174	\N
ce3094c5-eaba-4eac-b1fe-5e58ecf24b43	e95c44e3-09ed-4163-bdfa-1cf9194d054d	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	4	Autem admoveo denique.	2024-03-16 17:44:52.51174	\N
86de0355-1a57-47a3-9e53-c966aabdd84a	68639a14-05af-420d-af99-80053106aaf2	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	4	Tum peior amiculum conqueror correptius combibo denique crinis arbustum.\nBeatae peccatus comparo cras desidero tres.	2024-03-16 17:44:52.51174	\N
0367e6f9-daf9-4570-b507-c3f02a3afa82	44413b44-a362-48dc-a433-86275da7a7ba	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	5	Clamo claustrum decor taedium.\nBestia aegrus nam censura tabesco brevis abstergo stips celebrer.	2024-03-16 17:44:52.51174	\N
e9cc465f-dcb1-4c72-b8fc-396207427dcd	8af374f7-7738-4939-b7f5-9a348d282d59	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	5	Adeptio desparatus vitium alveus vapulus architecto tripudio adulatio.\nAdamo suasoria similique reprehenderit.	2024-03-16 17:44:52.51174	\N
363d6a24-5fd2-4fe8-9d1b-dbb04d0b8353	47a59dfd-9d2d-4d68-ae18-3d853c99294f	92198596-6adf-47b4-8bac-c6d38b9d501b	3	Vesper cattus bonus admoveo dedico aranea agnitio vinum ullus coma.\nAegrotatio utrimque blanditiis curriculum compono.\nAdstringo laudantium viduo.	2024-03-16 17:44:52.564969	\N
7de8e6b5-571e-41c0-bcdd-ec1e7ded10d4	e95c44e3-09ed-4163-bdfa-1cf9194d054d	92198596-6adf-47b4-8bac-c6d38b9d501b	2	Supra magni delicate ulterius ustulo alveus conor abeo animi mollitia.\nCurto dignissimos varius provident sortitus caelestis abundans balbus succurro.\nCum alias cohaero tempus adsum.\nSupellex adversus tutamen volaticus aureus alias aspernatur territo appono.	2024-03-16 17:44:52.564969	\N
22b97354-6932-4f72-8b08-4677fe0dcb43	44413b44-a362-48dc-a433-86275da7a7ba	92198596-6adf-47b4-8bac-c6d38b9d501b	4	Crur vindico corroboro.\nVestigium deprecator aestivus cenaculum vos universe caput spargo admitto.	2024-03-16 17:44:52.564969	\N
ef9a0ccb-02f8-4189-9f78-1a8838d3fd60	68639a14-05af-420d-af99-80053106aaf2	92198596-6adf-47b4-8bac-c6d38b9d501b	3	Ea itaque confero audax talus vigilo.\nConvoco quas supellex cupiditas cunctatio.	2024-03-16 17:44:52.564969	\N
218debf6-f337-4607-8d9f-e828c8529d54	88d6c654-0e9e-4a35-9caf-c3a67c056f8a	92198596-6adf-47b4-8bac-c6d38b9d501b	4	Vomica canonicus neque adhuc vomica angelus.	2024-03-16 17:44:52.564969	\N
dea36e1c-dccf-4320-a84b-b24db89491d7	432f05e7-dbdb-4d28-baee-f33feeb1c3eb	92198596-6adf-47b4-8bac-c6d38b9d501b	3	Sopor averto vix derideo vis amplitudo valeo colligo debeo.\nDepulso vespillo volo cubicularis clarus territo nemo uterque temporibus.\nOdio celebrer acer toties deleo succedo cura repellat tertius.	2024-03-16 17:44:52.564969	\N
7ed28192-4d7d-49e7-9611-86137db05893	5bbd7e6b-ce25-4155-8fb0-9614c1d7ddcf	92198596-6adf-47b4-8bac-c6d38b9d501b	2	Antiquus vereor beatus eaque.\nDignissimos versus cupiditas absconditus supra.\nSoleo cui ventus substantia rerum tantum copia.	2024-03-16 17:44:52.564969	\N
bdc10547-a46b-4554-a130-e42c7c6f3e4a	86cfe2b1-a946-43f0-8e77-d075a13d9972	92198596-6adf-47b4-8bac-c6d38b9d501b	3	Atque spectaculum arguo illum quis virga commodo condico animadverto.\nDefessus subnecto demo cruciamentum.\nAmet victoria voco aliquid aeternus vilis surculus assumenda acer.\nCultura tibi tracto trans tardus vilitas crinis pauci via.	2024-03-16 17:44:52.564969	\N
512b91ff-22bb-4e9c-8c5d-be884e47bd5c	6d0bd165-1e34-4948-bc1e-bf336d3bcd9e	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	1	Toties admitto vado vel illo usus deripio.\nVerecundia arbustum eos.\nAqua hic vergo accendo dignissimos.\nCibus aegre provident tredecim cupio degero artificiose.	2024-03-16 17:44:52.51174	2024-03-16 21:07:24.30728
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservations (id_reservation, id_customer, id_seating, reservation_status, clarification, reservation_date, start_time, end_time) FROM stdin;
dea3bd77-b8db-4392-9e1f-493559a8ba6e	5bbd7e6b-ce25-4155-8fb0-9614c1d7ddcf	1eb46a8a-ee3e-421a-b838-93c0883949fb	cancelled	Business meeting	2024-03-16	10:36:00	12:36:00
eb5b1616-f51a-4bc9-80ec-e16d80e46c68	44413b44-a362-48dc-a433-86275da7a7ba	b8484c4f-a79a-4888-b274-000676379676	completed	Birthday party	2024-03-17	14:36:00	16:36:00
c0b84383-ea0c-4d55-95ad-49bda20baf56	91d0795c-0792-4f93-b6b8-9fa3c02b21a4	b8484c4f-a79a-4888-b274-000676379676	pending	Family dinner	2024-03-16	16:32:00	18:32:00
cae28896-7ca5-468b-a07c-1ee073b12093	52a42ac5-0a32-40fd-9d50-b426297b1cd0	1eb46a8a-ee3e-421a-b838-93c0883949fb	cancelled	Anniversary celebration	2024-03-14	12:10:00	13:10:00
fda91400-19dd-4648-b58e-f19b01d9146d	5bbd7e6b-ce25-4155-8fb0-9614c1d7ddcf	11009d94-a70a-4885-a215-71d8c3bcc3b0	cancelled	Birthday party	2024-03-11	10:49:00	12:49:00
0ee9c4c0-7b97-4910-87e7-830d3768ac86	baeac644-4aec-42b1-805d-0323c366adc3	b8484c4f-a79a-4888-b274-000676379676	pending	Business meeting	2024-03-17	17:35:00	18:35:00
effbf442-5216-4380-b070-51eda45d6c80	355a9829-a8b5-4d88-baa8-9fa627730412	b8484c4f-a79a-4888-b274-000676379676	completed	Anniversary celebration	2024-03-09	12:46:00	14:46:00
4ecee401-1e4f-4c39-8795-d9e15f20ab39	e95c44e3-09ed-4163-bdfa-1cf9194d054d	b514fea0-4bf4-4969-8d55-0e4f1734f80a	cancelled	Date night	2024-03-20	15:25:00	17:25:00
30e8be8f-da25-463d-8e8f-967d07c3df0d	b7829c34-636f-4442-80d4-c0a85810f137	f8e1a52a-38fd-4b75-aca7-b15d612b8654	completed	Date night	2024-03-09	16:29:00	17:29:00
85904073-3b5f-4ed7-b342-e3faabc12cb3	904eab89-87cb-4829-95c9-b7e55c68c523	e6c59dd8-432c-4081-a366-870950dfb023	pending	Date night	2024-03-14	13:05:00	15:05:00
2df1d5c2-36ae-47a2-a78c-b1484e17876b	355a9829-a8b5-4d88-baa8-9fa627730412	09b0ca6b-ffef-456c-93c2-27bcba6469ad	pending	Casual lunch	2024-03-21	16:40:00	17:40:00
593118aa-95a8-4d64-9620-c9f181e0685c	f45a4877-81fb-4d83-a87f-fe3ea1f56848	6e2ac110-a932-4e47-bc5c-945965cd47a8	pending	Business meeting	2024-03-15	16:55:00	17:55:00
bc3702c6-d96f-4c10-9318-fbca78ebce92	f45a4877-81fb-4d83-a87f-fe3ea1f56848	9c179713-1cc5-4f04-baca-0df06ec7ce79	cancelled	Anniversary celebration	2024-03-17	17:08:00	18:08:00
\.


--
-- Data for Name: restaurant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurant (id_restaurant, id_working_hours, id_details, id_address, name, restaurant_phone) FROM stdin;
92198596-6adf-47b4-8bac-c6d38b9d501b	e2227be6-f553-44ad-b16c-13ed2b27a8be	05a43668-40c7-482f-aa51-2a3a5cb45d92	8fb452ae-a05e-48be-b13f-3be04eb2fcd7	Sunset Cafe	+79079452
6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	34f918f9-cf62-4206-8ebd-7f62b49bbe11	475d310c-f000-4c96-94c3-e354b3d7c1fd	4b95aff6-7ff2-4086-8f53-37f39266d32c	NAMERESTAURANT	+70707636
b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	e793c792-bc48-4a2c-b579-9876f0b4675c	b37b2830-c65b-4c33-baa9-ebe50d36a7db	d2bb97b3-f2ce-420a-936d-4d35927d475a	TESTNAME	79999999999
\.


--
-- Data for Name: restaurant_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurant_address (id_address, country, state, city, street) FROM stdin;
8fb452ae-a05e-48be-b13f-3be04eb2fcd7	Fiji	Louisiana	Blue Springs	Doyle Views
4b95aff6-7ff2-4086-8f53-37f39266d32c	RANDOMCOUNTRY	RANDOMSTATE	RANDOMCITY	RANDOMSTREET
d2bb97b3-f2ce-420a-936d-4d35927d475a	TESTCOUNTRY	TESTSTATE	TESTCITY	TESTSTREET
\.


--
-- Data for Name: restaurant_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurant_details (id_details, id_cuisine, social_media_links, additional_info) FROM stdin;
05a43668-40c7-482f-aa51-2a3a5cb45d92	2855ad43-9422-4283-bd00-cb3d452c0e8a	{"media1": "https://moist-viola.com"}	Absque tertius aegrus tyrannus color dedecor ultra victus calamitas solus.\nCultura magni cupiditate tremo a cumque tricesimus.
475d310c-f000-4c96-94c3-e354b3d7c1fd	e611f5cd-a124-483a-a76a-591a3bfdd2b1	{"media1": "https://cloudy-calibre.name", "media2": "https://belated-freelance.name", "media3": "https://altruistic-rubbish.biz"}	LOREM IPSUM
b37b2830-c65b-4c33-baa9-ebe50d36a7db	a35fadf9-94ac-43e5-b303-fa6996c590de	{"media1": "https://luxurious-detainee.name/"}	LOREM IPSUM
\.


--
-- Data for Name: restaurant_special_offers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurant_special_offers (id_offer, id_restaurant, offer_name, description, start_offer, end_offer) FROM stdin;
12f481d9-a2e8-4d39-a30f-4467771a14c6	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Free Cocktail with Every Order!	Carbo derelinquo ars laboriosam verbera veniam.\nCorrigo voluptatibus tredecim templum capto civitas.	2024-03-11	2024-03-25
b9a06113-03ba-4e58-a68a-ee47dc53281c	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Weekend Special Menu!	Comedo ea ventosus aperiam vesco reprehenderit conventus quas aedificium paens.	2024-03-10	2024-03-24
90f57c88-a477-4657-9350-936f5fbced37	92198596-6adf-47b4-8bac-c6d38b9d501b	Special Lunch Deals Daily!	Sui anser demulceo.	2024-03-15	2024-04-05
\.


--
-- Data for Name: restaurant_staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurant_staff (id_staff, id_restaurant, name_staff, "position", contact_number) FROM stdin;
adbf43ed-3b00-424b-8be5-3c60741f5c07	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Eric Ritchie	Coordinator	1-492-792-3785 x58787
ece56942-32b5-4105-ab12-c83170766316	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Cindy Gerhold-Kunze	Facilitator	551.505.1253 x4655
a1bcad96-8a65-4b71-a3fa-d4c4abec1bef	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Eunice Harvey I	Supervisor	(806) 871-5929
ec90e966-4fb4-42d2-b57d-19fe69968d5b	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Lucas Pfeffer	Administrator	(414) 871-0178
3e5e9971-677e-4aa6-9106-3468fe82d6f7	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Marvin Williamson	Consultant	840.492.5130 x18367
371b682c-ad04-4dd9-be35-b9db26afd53f	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Patricia Bailey	Officer	1-403-467-0593 x827
0d829b6b-acc8-4d24-8f98-e4769559dc13	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Annette Streich	Architect	413.486.0853 x849
6c7bd497-8422-4f8a-97dc-48c4afe6e028	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Ken Lowe	Engineer	208.755.5575
2b82cbd6-c8a3-4906-9f50-0b5c0022317e	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Ignacio Crist	Producer	353-861-6809 x8948
ee1dc7e1-8b18-4284-b85c-3b2bd4658043	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Louise Wyman	Strategist	(567) 692-4070
a8a3a0e0-0f0e-4bb7-a466-437b50c37838	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Charlie Fadel	Officer	1-745-332-9719 x3156
5a53f949-5f54-4894-a09f-aaf699d4c0c7	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Jackie Wintheiser	Liaison	(609) 402-7745
7fab8005-38ec-4a8b-ba52-ef364805737a	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Mr. Christopher Nitzsche	Officer	425-447-6052 x83240
ccee2911-6887-469c-bacc-27e9b8abf00a	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Marsha Franecki-Lowe	Orchestrator	1-823-242-5301 x3740
cfee300d-0cdc-4599-920f-4fc0c5b03674	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Crystal Dicki	Associate	1-214-709-3463 x6141
f5a23e0e-e22a-4d27-b34f-b3bd05ad9394	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Dr. Yvette Kiehn	Assistant	(707) 259-0128 x9692
ea17acc8-4356-46e7-ad40-e0aa7d32d049	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Annette Shanahan	Planner	516.557.8533 x4403
5df1e61f-141c-4a6f-b582-3b13bca477a8	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Olivia Towne-Goyette	Supervisor	(941) 539-5745 x67644
68870258-e27b-4bf2-8166-8c2928bfc974	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Elena Cartwright	Specialist	(235) 969-1115
02b45601-a7e4-42d3-9aed-1471b8a3744f	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Alexander Turcotte MD	Associate	1-967-814-2433 x6313
f70ca154-5681-4405-93af-a34374be30ea	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Theodore Von	Executive	247-298-7599
8b3d554f-78cc-4d02-972b-658c1399e4d8	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Judith Smitham	Director	1-572-309-3841 x252
45ba34f0-d7e9-439a-acaf-9bee78565c7e	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Benjamin Hoppe	Specialist	1-710-501-5401
283ad5ee-7ae7-4b3f-ba57-a07333dcd83b	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Shelly Nitzsche DVM	Consultant	1-652-595-8493 x701
a985ffef-8d6f-4987-84b7-cc3b6f94ce44	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Mrs. Hattie Ratke	Consultant	1-593-453-0594 x19461
10bb4063-6fa2-42dc-8d95-082289cac4e0	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Sally Cole	Executive	(860) 374-3704 x792
52455d48-8388-42ca-812c-6a7896589a78	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Heidi White I	Producer	653-833-5855 x85378
5482390a-37f8-49f3-9bdd-616fdea8907d	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Kent Jones	Coordinator	860.513.7279 x356
2e2b2211-d571-4cfb-956e-8e67468f27c7	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Gayle Nienow-Renner	Consultant	431.228.9211 x27708
ed8abde0-49be-4d7b-b927-c449afa2e86e	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Alexander Crona	Assistant	511-937-6679
dd727f77-fa78-4774-b7de-9be3ce7abb14	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Bernice Rath	Agent	600-454-8775 x07518
1bfa3c90-6ad2-4b4c-a227-4d7d2c4e587d	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Donald Durgan III	Director	458.770.7258
3fbf8a1d-2dd4-40dd-86cb-95f09a1d1083	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Dr. Jennifer Kris-Farrell I	Planner	927-840-6552 x8198
ec0d1686-0d4c-43b8-b700-9798d2a0bba0	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Peter DuBuque I	Assistant	982.352.7084 x224
aaba1b86-daed-4622-918d-53be52d02486	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Loren Kuphal	Agent	(534) 955-2698 x07375
6b798c3d-7075-4dd8-a74d-02a14bc4e8dd	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Javier Block	Agent	(403) 685-7868 x002
866a0525-4262-44e5-b768-081abef99c57	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Margie Dickinson	Coordinator	(585) 202-6852
f340237a-2750-46a8-942c-56bd111dfe0c	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Franklin Cole Jr.	Facilitator	985-301-9185 x8692
2284ff8c-deee-422f-8aed-c13ef810de76	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Jay Rosenbaum	Executive	992-749-3460 x63392
88ddfad1-d0e0-48d7-941e-6621c3187f23	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Terrell Gerhold	Officer	925.515.0570 x93990
18cd6194-e195-46ad-8ad3-2ddea489686f	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Julian Borer	Consultant	(480) 728-7252
bb7aa5ee-2a42-4fb2-8fc9-8232d521bb4e	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Eugene Bauch	Associate	(378) 878-1364 x4747
c8455c5a-724e-44e1-8ff5-5fcfe5aaf696	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	Darrell Treutel	Director	596-998-3186 x73421
03ee602f-7a1b-4c51-aa53-cd78c073514a	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Russell Reilly	Manager	919.213.1814 x970
7e26a16c-1e97-47cf-b901-fb8b7717c6a7	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Regina King-Brown	Administrator	687.363.6293 x4972
12ae1459-1595-4692-bdb5-ff53fffe9a81	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Bryant Beier	Designer	1-632-527-7136 x6176
826d7fba-bca0-4573-89d2-db9b75283b8f	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Dr. Devin Terry	Analyst	201-455-4367 x931
0f42c421-fa92-4df7-b662-e88187c31d6a	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Jaime Cummerata I	Analyst	689.853.6868 x6881
ac335a23-2d83-481e-891f-f711cbcdeb8f	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Marlon Hammes	Representative	1-458-686-0640 x0665
1875c1fd-8cfb-4380-b5b9-0d98388f72f0	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Bryant Monahan	Technician	902.830.5705
6c327a76-f731-4421-bfca-971bbafbdfff	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Louise Casper	Analyst	(615) 839-2085 x7021
071d0a57-ae1a-402b-b221-f6cd1d8938ab	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Van Rosenbaum Sr.	Assistant	674.269.3243 x5408
38ca5b92-84c3-4200-a053-565b1c9d3334	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Robin Mosciski	Consultant	1-858-450-6226 x91917
2b82e37a-8874-4f21-8881-31f2e3287ab5	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Lionel Kohler	Administrator	555-362-9439 x190
c054e93c-6703-4ac0-a51a-c8b485ea5360	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Lorene Heller V	Producer	913.723.5277 x92015
ed3927e5-f4d7-4037-b40f-7f75475b13de	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Olga Macejkovic	Strategist	(706) 213-6558 x32524
69c3b996-4248-4136-9046-5c4ec0825ba8	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Lawrence Witting	Assistant	848.429.4934 x5111
d06f3fb0-548b-4077-af51-234f178c03e7	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Fannie Ledner	Director	869.449.4449
ee175110-b398-4e50-b1dc-d1281132ead7	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Miss Angelina Kautzer	Officer	850.879.3021 x90178
26690b26-4c29-47bd-ae32-885c0b92e999	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Terrell Reynolds	Planner	944-775-7066 x85070
f08cf9e0-c99e-46c5-a305-8eaaee343220	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Dexter Corkery	Consultant	351-441-8069 x7219
bca08c46-e9e5-496e-85d6-98b1f857c140	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Jody Emard	Producer	898-851-0040 x524
d4cb6d44-c67b-40a9-8e7b-07ce8d253610	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Helen Feest	Assistant	615.572.4458
ff3100bb-2e36-4872-b10e-9c8b2c8a366a	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Barry Wisoky I	Specialist	1-736-961-5414
fd90baf8-1523-47f5-a383-528560d11f9b	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Meredith Ledner	Consultant	(678) 539-5716 x7856
750d229b-5643-4b0a-9d81-c61a5b241fa7	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Ismael West-Rohan	Representative	455-977-2450 x6827
f6770a23-24e1-40cc-9104-a81636860371	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Blake Christiansen	Director	1-445-264-0509 x836
0e02948b-51a7-4f42-8ce0-19082de7ebbf	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Mr. Larry Harber	Agent	474.635.4820 x4835
548a8182-5c40-44db-81f1-3df9a3907299	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Edmond Satterfield	Manager	632.558.2993 x761
66457dea-06cd-40c7-a3e3-3ced9c0e90f5	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Randolph Johnston	Facilitator	822.472.2734
213416c3-cc68-4c73-aaa7-38731cf5e50d	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Rosie Ullrich	Administrator	1-844-823-9600 x0215
3f932012-5b5d-4270-a693-79705572f52f	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Kelli Borer	Coordinator	601.786.4370 x7365
b40d278d-d13d-45f6-8a5f-27e53abda635	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Toni Metz	Manager	(383) 605-9668 x43704
612a7c9c-f902-405a-abd0-97406a290931	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Andrew Spinka	Orchestrator	279-256-9310
84576601-afe2-4aa6-9fed-b26956c1f7a3	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Flora Schimmel	Agent	345.386.4188 x5437
8cd5a82a-6862-4dca-85f4-d65bc91a774a	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Sam Effertz	Representative	(387) 486-0750 x975
278b7ffc-cc7d-4375-acf3-1cffc32527cd	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Julio Smitham III	Engineer	911.696.9748 x076
7659e7c2-49ee-402f-9d67-c71905099502	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Jodi Boyle	Technician	726-595-0855 x477
f79beac7-4366-46bf-af3b-e512027b63f7	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Corey Rohan	Producer	(426) 404-7870 x7094
e27f4098-0688-4d64-81ef-899f68c7b1a5	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Thelma MacGyver	Representative	1-782-943-9845
51c511b6-6cbe-4b52-ad44-10227f2e40d1	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Sharon Maggio	Consultant	1-529-470-3570 x240
dd3eb398-58ec-4b14-9ee0-276333d09d48	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Arnold Huel	Producer	1-466-871-5874 x1866
d5a02c10-25fa-4f14-b18a-ff0e51ced404	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Bennie Graham	Coordinator	272-960-2472 x26198
4f751db1-9678-48cc-8fb2-9482b4052fdc	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Katie Lehner DDS	Producer	225-578-6700 x07157
da240dea-1c7f-4fb0-9bd5-9482681ac784	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	Roland Spinka	Executive	1-346-286-5940 x55782
291e2055-6335-4f37-a0a0-07a9a4ea7c2c	92198596-6adf-47b4-8bac-c6d38b9d501b	Courtney Wolf	Facilitator	1-737-708-3446
9463aa6d-ea6b-47a0-989d-68ff18e50473	92198596-6adf-47b4-8bac-c6d38b9d501b	Heather Ruecker	Associate	(717) 965-3711 x696
1617c58f-7c68-4bc6-94cc-f42990308804	92198596-6adf-47b4-8bac-c6d38b9d501b	Shelley Ferry	Architect	1-553-277-8958 x93189
9fc57fe1-f32f-45e7-98d9-6cde1a038e8c	92198596-6adf-47b4-8bac-c6d38b9d501b	Tommy Ankunding	Coordinator	637.410.2467 x708
9e3e6ed7-cfc5-44cf-93ca-12175f0cec40	92198596-6adf-47b4-8bac-c6d38b9d501b	Miss Rochelle Yost	Technician	1-758-709-8551 x7769
42e53ca8-00a6-4d09-8e55-a1f50e77763e	92198596-6adf-47b4-8bac-c6d38b9d501b	Ms. Bobbie Parisian	Representative	1-484-264-7599 x0504
f0e015a4-d83b-4ebe-b555-ee939ac46e9d	92198596-6adf-47b4-8bac-c6d38b9d501b	Guillermo Towne	Director	737-380-7215
3355773a-8bfa-4f35-966a-3d5ec21c2842	92198596-6adf-47b4-8bac-c6d38b9d501b	Ms. Isabel Fritsch	Liaison	1-485-341-9559 x79288
867832b6-41b3-40d6-9173-6b8f8b18d130	92198596-6adf-47b4-8bac-c6d38b9d501b	Rene Tremblay	Assistant	1-718-374-7210 x18565
ab32961d-db01-46ec-8ec2-2161afc26585	92198596-6adf-47b4-8bac-c6d38b9d501b	Carol Gulgowski-Ankunding	Liaison	694-941-4599 x0020
ab481e79-a0fb-4f06-8fa0-f7cebfdd794a	92198596-6adf-47b4-8bac-c6d38b9d501b	Leonard Brown	Developer	1-268-833-5108 x32781
b68dbfbd-a5c2-4c1c-9efb-91ef937267cb	92198596-6adf-47b4-8bac-c6d38b9d501b	Rodney Fay-Predovic	Agent	(334) 898-6211 x92506
f9457d17-df01-4790-b148-62f9afce6322	92198596-6adf-47b4-8bac-c6d38b9d501b	Teresa Jaskolski	Agent	217.597.6570 x389
bb0e805c-19ff-400d-ac2e-4cf832bce128	92198596-6adf-47b4-8bac-c6d38b9d501b	Douglas Nienow-Auer	Analyst	417-325-2076 x672
77260f9f-25a6-467d-b3fd-e2af7e740783	92198596-6adf-47b4-8bac-c6d38b9d501b	Gayle Nitzsche	Consultant	731-806-8787 x35137
690f8453-a5f6-4169-95f8-d316f642990c	92198596-6adf-47b4-8bac-c6d38b9d501b	Kristy Stokes	Assistant	1-402-734-9198 x68838
cf1475a6-06f5-4796-8b1a-4d18525e6fa7	92198596-6adf-47b4-8bac-c6d38b9d501b	Ana Ratke	Director	(382) 668-9783 x72619
fad71e1f-a8e3-4bc1-94b9-785474a31c1f	92198596-6adf-47b4-8bac-c6d38b9d501b	Lora Kozey	Liaison	(551) 536-8054 x0659
86e6295c-5a13-4b4f-985d-52f1389248b9	92198596-6adf-47b4-8bac-c6d38b9d501b	Dave Koch	Technician	1-704-845-3568 x0319
095e45aa-6448-41e3-b64a-f214766b3585	92198596-6adf-47b4-8bac-c6d38b9d501b	Dana Aufderhar	Designer	1-404-521-0689 x535
daa711c2-7acf-4ff8-bab8-b7f2a05dcfec	92198596-6adf-47b4-8bac-c6d38b9d501b	Dorothy Frami	Orchestrator	1-930-358-0993 x116
df206283-431e-41a8-9af3-e9d327ae3547	92198596-6adf-47b4-8bac-c6d38b9d501b	Joan Kuhn	Engineer	1-850-820-9116 x3741
e6a3bdc5-9e24-46d8-9405-b94be091c40e	92198596-6adf-47b4-8bac-c6d38b9d501b	Daniel Breitenberg MD	Engineer	682.329.2452 x63298
94a2a084-aac8-44ef-bb7d-49dde739e1f0	92198596-6adf-47b4-8bac-c6d38b9d501b	Patty Johnston DVM	Supervisor	560.400.1159 x70636
6f5d85b4-a763-4882-a8ec-0b0b7a4a7990	92198596-6adf-47b4-8bac-c6d38b9d501b	Lynn Durgan	Representative	1-607-996-5811 x61234
022be324-18e8-4adb-b53c-1bbdd549c560	92198596-6adf-47b4-8bac-c6d38b9d501b	Dr. Al Boyle	Planner	(505) 638-1059 x3243
a32cfc63-db02-48d9-9500-de06a5e4e604	92198596-6adf-47b4-8bac-c6d38b9d501b	Viola Sporer	Designer	(250) 754-1037 x764
7b65c692-654a-452e-9ff9-8957017304b1	92198596-6adf-47b4-8bac-c6d38b9d501b	Jan Ankunding	Administrator	718.693.4276 x84110
60d405c5-49cd-4b38-9850-ef2e9998864b	92198596-6adf-47b4-8bac-c6d38b9d501b	Henrietta Smith	Facilitator	(408) 228-5942
18532b65-62c3-40c3-866e-baf66e483b55	92198596-6adf-47b4-8bac-c6d38b9d501b	Billy Donnelly	Liaison	1-207-908-2803
6b9f485f-c4d9-4e94-8df7-45407c545bc9	92198596-6adf-47b4-8bac-c6d38b9d501b	Enrique Kihn	Developer	1-454-765-1883 x23214
beaa62a0-e5c7-406d-be5e-147ded9b7105	92198596-6adf-47b4-8bac-c6d38b9d501b	Ray Doyle-Dickens	Representative	775.766.3942
2eaffbf4-a353-4c61-aaa8-5743c608545b	92198596-6adf-47b4-8bac-c6d38b9d501b	Wanda Langworth	Agent	377.672.6951
a873bdbc-9ea2-4240-9382-088de0f1dd3d	92198596-6adf-47b4-8bac-c6d38b9d501b	Pam Bauch	Orchestrator	933.547.0797 x34183
ac9a08ad-d53e-4ff2-bb2b-fe07563d8e5e	92198596-6adf-47b4-8bac-c6d38b9d501b	Tracey Wiegand Sr.	Representative	(258) 896-2956 x426
812e6812-8b4c-49d1-8797-208013c4dee5	92198596-6adf-47b4-8bac-c6d38b9d501b	Alton Murazik	Coordinator	(490) 260-0480 x5842
bc41d4ab-44f7-4d55-a623-d46cc11e05a1	92198596-6adf-47b4-8bac-c6d38b9d501b	Glenn Lowe DVM	Executive	1-724-978-8560 x736
\.


--
-- Data for Name: seating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seating (id_seating, id_restaurant, seating_status, capacity) FROM stdin;
1eb46a8a-ee3e-421a-b838-93c0883949fb	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	free	5
b8484c4f-a79a-4888-b274-000676379676	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	free	9
88441058-acc8-486b-a066-547f3b6898c4	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	free	10
7f6daa73-c55e-48ca-8ce7-a95118a5151a	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	not_available	9
b514fea0-4bf4-4969-8d55-0e4f1734f80a	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	free	2
8f3c1ac6-8187-4af0-bbd5-215ad1a1ac6c	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	reserved	9
b7627d99-a395-4e90-8df1-e1432fc6c52e	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	reserved	4
4e15c87b-ea31-4987-a3d1-e16d3a02c30c	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	free	10
11009d94-a70a-4885-a215-71d8c3bcc3b0	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	not_available	9
7fc28e9d-600e-430d-9a7f-78b672ace99c	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	reserved	8
fb8dae24-7f91-4f69-85c4-061c1635d912	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	not_available	5
04a6e968-d4a8-40fb-95f3-df31349b0b64	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	not_available	5
9c5f279a-cffb-4719-8e41-c1d538a86638	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	reserved	4
904e8ce2-2a08-4b19-96ae-0b681d010899	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	free	2
e8f14bfa-1330-488d-a110-a9d3ae0fc17b	6a8e8e32-4d7d-4987-a021-f6e4e5f7befe	not_available	10
672cba42-dbe1-4b88-b062-a34c2558cc49	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	free	4
98610f9e-5891-440a-8861-39ccb7ac5a39	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	not_available	8
c16f07d2-d3bd-4572-a779-79bb714d2c1e	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	not_available	10
8db96bd7-e5bf-4d68-99ce-728380ca87f3	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	reserved	7
6e2ac110-a932-4e47-bc5c-945965cd47a8	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	free	3
86a36a65-adf6-46c8-bf99-0d2e82bb557b	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	reserved	10
f8e1a52a-38fd-4b75-aca7-b15d612b8654	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	free	1
48eecd09-0099-495c-b21a-211b88378421	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	free	5
8821d3a1-7219-4669-a36e-6f570c3e2076	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	free	6
83476596-bbe1-4520-9d30-ff00dcc50ffd	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	free	5
1d23857d-df94-4f6c-bb1e-70fc7055bf5a	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	reserved	8
0025c45c-9177-433b-b12e-581dc2d54fff	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	not_available	2
e6c59dd8-432c-4081-a366-870950dfb023	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	free	9
0e186ee7-e7cd-4cc3-82d8-0f91a25cea72	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	reserved	2
2ebc567d-5294-4bae-abe3-be0d59c28b77	b9a8d6a5-5f4f-4e1f-8f4e-249fe087e2f1	reserved	7
dfdd8305-5e2f-490d-800e-2d2485c5dd2c	92198596-6adf-47b4-8bac-c6d38b9d501b	free	2
f52ba144-b69c-4aa3-9269-5f11ab1124f6	92198596-6adf-47b4-8bac-c6d38b9d501b	free	5
4f5a15fc-46ed-4689-ba17-0748c5462c6e	92198596-6adf-47b4-8bac-c6d38b9d501b	reserved	2
8888ffbe-db42-4bb9-9b67-76de7235acb7	92198596-6adf-47b4-8bac-c6d38b9d501b	not_available	5
b80666c1-d422-4cdb-ad4a-7b1685031aa2	92198596-6adf-47b4-8bac-c6d38b9d501b	not_available	10
6a9880fc-788b-4a6d-8b9b-e92d56703bf6	92198596-6adf-47b4-8bac-c6d38b9d501b	not_available	8
6346a916-8ff9-41a4-b986-fafa4208814a	92198596-6adf-47b4-8bac-c6d38b9d501b	free	5
e8142afa-74f1-453f-9bd1-1b1c2d9e875e	92198596-6adf-47b4-8bac-c6d38b9d501b	not_available	9
483b1ebe-37a5-4291-8e3a-67f67f2a77f2	92198596-6adf-47b4-8bac-c6d38b9d501b	not_available	7
99b6ee7c-b005-453c-b1ae-e4867c142fdc	92198596-6adf-47b4-8bac-c6d38b9d501b	free	8
ccd9eb1e-aabe-4574-a881-001d62e325de	92198596-6adf-47b4-8bac-c6d38b9d501b	not_available	7
c8f26125-d129-4b7d-9918-ef4300b08de1	92198596-6adf-47b4-8bac-c6d38b9d501b	reserved	5
09b0ca6b-ffef-456c-93c2-27bcba6469ad	92198596-6adf-47b4-8bac-c6d38b9d501b	free	2
9c179713-1cc5-4f04-baca-0df06ec7ce79	92198596-6adf-47b4-8bac-c6d38b9d501b	reserved	8
b1bc66ff-c7f6-448b-9750-e0589f8c3f0f	92198596-6adf-47b4-8bac-c6d38b9d501b	not_available	2
\.


--
-- Data for Name: working_hours; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.working_hours (id_working_hours, opening_time, closing_time) FROM stdin;
34f918f9-cf62-4206-8ebd-7f62b49bbe11	08:20:00	23:15:00
e2227be6-f553-44ad-b16c-13ed2b27a8be	09:20:00	23:05:00
e793c792-bc48-4a2c-b579-9876f0b4675c	09:00:00	18:00:00
\.


--
-- Name: cuisine cuisine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuisine
    ADD CONSTRAINT cuisine_pkey PRIMARY KEY (id_cuisine);


--
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id_customer);


--
-- Name: customer_reviews customer_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_reviews
    ADD CONSTRAINT customer_reviews_pkey PRIMARY KEY (id_review);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id_reservation);


--
-- Name: restaurant_address restaurant_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant_address
    ADD CONSTRAINT restaurant_address_pkey PRIMARY KEY (id_address);


--
-- Name: restaurant_details restaurant_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant_details
    ADD CONSTRAINT restaurant_details_pkey PRIMARY KEY (id_details);


--
-- Name: restaurant restaurant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant
    ADD CONSTRAINT restaurant_pkey PRIMARY KEY (id_restaurant);


--
-- Name: restaurant restaurant_restaurant_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant
    ADD CONSTRAINT restaurant_restaurant_phone_key UNIQUE (restaurant_phone);


--
-- Name: restaurant_special_offers restaurant_special_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant_special_offers
    ADD CONSTRAINT restaurant_special_offers_pkey PRIMARY KEY (id_offer);


--
-- Name: restaurant_staff restaurant_staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant_staff
    ADD CONSTRAINT restaurant_staff_pkey PRIMARY KEY (id_staff);


--
-- Name: seating seating_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seating
    ADD CONSTRAINT seating_pkey PRIMARY KEY (id_seating);


--
-- Name: working_hours working_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.working_hours
    ADD CONSTRAINT working_hours_pkey PRIMARY KEY (id_working_hours);


--
-- Name: cuisine cuisine_type_check_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cuisine_type_check_trigger BEFORE INSERT OR UPDATE OF cuisine_type ON public.cuisine FOR EACH ROW EXECUTE FUNCTION public.check_cuisine_type_exists();


--
-- Name: restaurant enforce_phone_number_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER enforce_phone_number_validation BEFORE INSERT OR UPDATE OF restaurant_phone ON public.restaurant FOR EACH ROW EXECUTE FUNCTION public.validate_phone_number();


--
-- Name: customer_reviews update_review_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_review_trigger BEFORE UPDATE ON public.customer_reviews FOR EACH ROW WHEN (((old.rating IS DISTINCT FROM new.rating) OR ((old.review_text)::text IS DISTINCT FROM (new.review_text)::text))) EXECUTE FUNCTION public.update_review();


--
-- Name: working_hours validate_working_hours_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validate_working_hours_trigger BEFORE INSERT OR UPDATE OF opening_time, closing_time ON public.working_hours FOR EACH ROW EXECUTE FUNCTION public.validate_working_hours();


--
-- Name: customer_reviews customer_reviews_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_reviews
    ADD CONSTRAINT customer_reviews_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.customer(id_customer);


--
-- Name: customer_reviews customer_reviews_id_restaurant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_reviews
    ADD CONSTRAINT customer_reviews_id_restaurant_fkey FOREIGN KEY (id_restaurant) REFERENCES public.restaurant(id_restaurant);


--
-- Name: reservations reservations_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.customer(id_customer);


--
-- Name: reservations reservations_id_seating_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_id_seating_fkey FOREIGN KEY (id_seating) REFERENCES public.seating(id_seating);


--
-- Name: restaurant_details restaurant_details_id_cuisine_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant_details
    ADD CONSTRAINT restaurant_details_id_cuisine_fkey FOREIGN KEY (id_cuisine) REFERENCES public.cuisine(id_cuisine);


--
-- Name: restaurant restaurant_id_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant
    ADD CONSTRAINT restaurant_id_address_fkey FOREIGN KEY (id_address) REFERENCES public.restaurant_address(id_address);


--
-- Name: restaurant restaurant_id_details_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant
    ADD CONSTRAINT restaurant_id_details_fkey FOREIGN KEY (id_details) REFERENCES public.restaurant_details(id_details);


--
-- Name: restaurant restaurant_id_working_hours_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant
    ADD CONSTRAINT restaurant_id_working_hours_fkey FOREIGN KEY (id_working_hours) REFERENCES public.working_hours(id_working_hours);


--
-- Name: restaurant_special_offers restaurant_special_offers_id_restaurant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant_special_offers
    ADD CONSTRAINT restaurant_special_offers_id_restaurant_fkey FOREIGN KEY (id_restaurant) REFERENCES public.restaurant(id_restaurant);


--
-- Name: restaurant_staff restaurant_staff_id_restaurant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurant_staff
    ADD CONSTRAINT restaurant_staff_id_restaurant_fkey FOREIGN KEY (id_restaurant) REFERENCES public.restaurant(id_restaurant);


--
-- Name: seating seating_id_restaurant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seating
    ADD CONSTRAINT seating_id_restaurant_fkey FOREIGN KEY (id_restaurant) REFERENCES public.restaurant(id_restaurant);


--
-- Name: TABLE customer_reviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.customer_reviews TO restaurant_client;


--
-- Name: TABLE reservations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.reservations TO restaurant_client;


--
-- Name: TABLE restaurant; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,UPDATE ON TABLE public.restaurant TO restaurant_manager;
GRANT SELECT ON TABLE public.restaurant TO restaurant_client;


--
-- Name: TABLE restaurant_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.restaurant_address TO restaurant_client;


--
-- Name: TABLE restaurant_details; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,UPDATE ON TABLE public.restaurant_details TO restaurant_manager;


--
-- Name: TABLE restaurant_special_offers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.restaurant_special_offers TO restaurant_admin;
GRANT SELECT ON TABLE public.restaurant_special_offers TO restaurant_client;


--
-- Name: TABLE restaurant_staff; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.restaurant_staff TO restaurant_admin;


--
-- Name: TABLE seating; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.seating TO restaurant_client;


--
-- Name: TABLE working_hours; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,UPDATE ON TABLE public.working_hours TO restaurant_manager;


--
-- PostgreSQL database dump complete
--

