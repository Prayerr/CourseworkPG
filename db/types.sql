-- Типы оплаты
CREATE TYPE payment_type AS ENUM ('credit_card', 'paypal', 'cash');

-- Тип кухни
CREATE TYPE cuisine_type AS ENUM ('Italian', 'French', 'Japanese', 'Russian', 'American', 'Derivative');

-- Статусы бронирования
CREATE TYPE reservation_status AS ENUM ('pending', 'cancelled', 'completed');

-- Статусы столиков
CREATE TYPE seating_status AS ENUM ('reserved', 'free', 'not_available');