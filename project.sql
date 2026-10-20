create database talently;

create type employment_status as enum ('employed', 'self-employed', 'unemployed');
create table users
(
    full_name      varchar(200),
    yearly_salary  int,
    current_status employment_status
);

insert into users (yearly_salary, full_name, current_status)
values (19000,
        'Max Schwarz',
        'self-employed');

insert into users (yearly_salary, full_name, current_status)
values (0,
        'Evgeniy Polupanov',
        'unemployed');

select *
from users;

create table employers
(
    company_name   varchar(200),
    address        varchar(300),
    yearly_revenue numeric(5, 2),
    is_hiring      boolean default false
);

create table conversations
(
    user_name     varchar(200),
    employer_name varchar(200),
    message       text,
    date_sent     timestamp default current_timestamp
);

insert into employers
values ('Learning Inc', 'Educationstreet 12, London', 0.87, true);
insert into employers
values ('Big Oil Inc', 'Slippery street 110, Houston', 112.55);
insert into employers
values ('Hipster Food', 'Avocadostreet, Berlin', 6.12, true);

insert into conversations (user_name, employer_name, message)
values ('Max Schwarz', 'Learning Inc', 'Hi, I like learning.');

-- drop table conversations, employers;

alter table employers
    alter column yearly_revenue set data type float;

alter table users
    alter column full_name set data type varchar(300);

select avg(users.yearly_salary)
from users;

alter table users
    alter column full_name set not null,
    alter column current_status set not null;

insert into users (full_name, current_status)
values ('Name', 'employed');

update users
set yearly_salary = null
where full_name = 'Evgeniy Polupanov';

alter table users
    add constraint yearly_salary_positive check ( yearly_salary > 0 );

drop table users;

create table users
(
    id             serial primary key,
    first_name     varchar(200) not null,
    last_name      varchar(200) not null,
--     full_name      varchar(404) generated always as (concat(first_name,' ',last_name)),
    yearly_salary  int check ( yearly_salary > 0 ),
    current_status employment_status
);
create table employers
(
    id              serial primary key,
    company_name    varchar(300) not null,
    company_address varchar(300) not null,
    yearly_revenue  float check ( yearly_revenue > 0 ),
    is_hiring       boolean default false
);
create table conversations
(
    id          serial primary key,
    user_id     int,
    employer_id int,
    message     text not null
);

create table products
(
    id              serial primary key,
    product_name    varchar(200) not null,
    price           int          not null,
    description     text         not null,
    amount_in_stock int,
    image           varchar(200) not null
);

create database sales_example;

create table sales
(
    id             serial primary key,
    date_created   date    default current_date,
    date_fulfilled date,
    customer_name  varchar(300)   not null,
    product_name   varchar(300)   not null,
    volume         numeric(10, 2) not null check ( volume >= 0 ),
    is_recurring   boolean default false,
    is_disputed    boolean default false
);

insert into sales (customer_name, product_name, volume, is_recurring)
values ('Max Schwarz',
        'A book',
        12.99,
        true);

INSERT INTO sales (date_created,
                   date_fulfilled,
                   customer_name,
                   product_name,
                   volume,
                   is_disputed,
                   is_recurring)
VALUES ('2022-01-18',
        '2022-03-11',
        'Company A',
        'A Nice Product',
        489.99,
        FALSE,
        TRUE),
       ('2022-01-18',
        '2022-05-01',
        'Company B',
        'Video Game Collection',
        3859.12,
        FALSE,
        FALSE),
       ('2021-12-05',
        NULL,
        'Company C',
        'Daily News Summary',
        4.99,
        FALSE,
        TRUE),
       ('2021-12-05',
        '2021-12-07',
        'Company A',
        'Good-looking carpet',
        1099.82,
        TRUE,
        FALSE),
       ('2022-02-21',
        '2022-02-24',
        'Max Schwarz',
        'Lord of the Rings Collection',
        69.99,
        FALSE,
        FALSE),
       ('2021-10-14',
        '2022-02-21',
        'Max Schwarz',
        'Lord of the Rings Movies',
        25.99,
        FALSE,
        FALSE),
       ('2022-06-01',
        NULL,
        'Max Schwarz',
        'Another book',
        8.99,
        FALSE,
        FALSE),
       ('2021-08-17',
        '2021-09-12',
        'Company D',
        'Vehicle Services',
        4999.99,
        TRUE,
        TRUE),
       ('2021-03-12',
        '2022-06-19',
        'Company D',
        'Vehicle Fleet',
        280000,
        FALSE,
        FALSE);

INSERT INTO sales (date_created,
                   date_fulfilled,
                   customer_name,
                   product_name,
                   volume)
VALUES ('2021-12-09',
        '2021-12-17',
        'Company Z',
        'A Tuck',
        109.0);

update sales
set product_name = 'A Truck',
    volume       = volume * 1000
where id = 11;

delete
from sales
where id = 11;

select customer_name, product_name, volume as total_sales, date_created, 'Hello world!' as static
from sales;

select *
from sales
where volume > 1000;

select *
from sales
where is_recurring is true;

select *
from sales
where (is_disputed is true)
   or (volume > 5_000);

select *
from sales
where date_created >= '2021-11-01'
  and date_created <= '2022-05-01';

select *
from sales
where date_created between '2021-11-01' and '2022-05-01';

select *
from sales
where volume > 1000
  and volume < 100_000;

select *
from sales
where customer_name <> 'Max Schwarz';

select *
from sales
where customer_name > 'Company A';

select *
from sales
where date_fulfilled is not null;

select *
from sales
where date_fulfilled - date_created <= 5;

select *
from sales
where date_fulfilled is not null
order by volume desc
limit 5 offset 3;

select distinct sales.customer_name
from sales;

create view base_result as
select *
from sales
where volume > 1000;
select customer_name, product_name
from base_result;

create database relations;

create table users
(
    id         serial primary key,
    first_name varchar(300) not null,
    last_name  varchar(300) not null,
    email      varchar(300) not null,
    address_id int          not null
);

create table addresses
(
    id           serial primary key,
    street       varchar(300) not null,
    house_number varchar(50)  not null,
    city_id      int          not null
);

create table cities
(
    id   serial primary key,
    name varchar(300) not null
);

insert into cities (name)
values ('Berlin'),
       ('New York'),
       ('London');

insert into addresses (street, house_number, city_id)
values ('Teststreet',
        '8A',
        3),
       ('Somestreet',
        '10',
        1),
       ('Teststreet',
        '1',
        3),
       ('My street',
        '101',
        2);

insert into users (first_name, last_name, email, address_id)
values ('Max', 'Schwarz', 'max@test.com', 2),
       ('Manuel', 'Lorenz', 'manu@test.com', 4),
       ('Julie', 'Barnes', 'julie@barnes.com', 3);

select u.first_name, u.last_name, c.name as city, a.street, a.house_number
from users as u
         inner join addresses as a on u.address_id = a.id
         inner join cities as c on a.city_id = c.id
where c.name = 'Berlin'
   or c.name = 'New York'
order by c.name desc;

select u.first_name, u.last_name, c.name as city, a.street, a.house_number
from addresses as a
         left join users as u on u.address_id = a.id
         left join cities as c on a.city_id = c.id
order by c.name;

INSERT INTO cities (name)
VALUES ('Munich'),
       ('Rome'),
       ('Tokyo'),
       ('Washington, D.C.');

INSERT INTO addresses (street, house_number, city_id)
VALUES ('Beerstreet', '91', 4),
       ('Beerstreet', '12', 4),
       ('Pizzastreet', '1', 5),
       ('Burgerstreet', '9', 2),
       ('Anotherstreet', '12', 1),
       ('Smallstreet', '11', 3);


INSERT INTO users (first_name, last_name, email, address_id)
VALUES ('Marina', 'Marks', 'marina@test.com', 2),
       ('Hans', 'Mayer', 'hansm@test.com', 5),
       ('Maria', 'Marionatti', 'maria@test.com', 7),
       ('Michael', 'Smith', 'michael@test.com', 8);

select distinct name as city
from cities as c
         left join addresses as a on c.id = a.city_id
         left join users as u on u.address_id = a.id
order by c.name;

select *
from users
         cross join addresses;

drop table users, addresses, cities;

CREATE TABLE users
(
    id         SERIAL PRIMARY KEY, -- Postgresql
    first_name VARCHAR(300) NOT NULL,
    last_name  VARCHAR(300) NOT NULL,
    email      VARCHAR(300) NOT NULL,
    address_id int          references addresses on delete set null
);

CREATE TABLE addresses
(
    id           SERIAL PRIMARY KEY, -- Postgresql
    street       VARCHAR(300) NOT NULL,
    house_number VARCHAR(50)  NOT NULL,
    city_id      INT          NOT NULL
);

CREATE TABLE cities
(
    id   SERIAL PRIMARY KEY, -- Postgresql
    name VARCHAR(300) NOT NULL
);

INSERT INTO cities (name)
VALUES ('Berlin'),
       ('New York'),
       ('London');

INSERT INTO addresses (street, house_number, city_id)
VALUES ('Teststreet', '8A', 3),
       ('Some street', '10', 1),
       ('Teststreet', '1', 3),
       ('My street', '101', 2);
INSERT INTO users (first_name, last_name, email, address_id)
VALUES ('Max', 'Schwarz', 'max@test.com', 2),
       ('Manuel', 'Lorenz', 'manu@test.com', 4),
       ('Julie', 'Barnes', 'julie@barnes.com', 3);

drop table cities, users, addresses;

create table employees
(
    id         serial primary key,
    first_name varchar(300)        not null,
    last_name  varchar(300)        not null,
    birthdate  date                not null,
    email      varchar(200) unique not null
);

create table intranet_accounts
(
    id       serial primary key,
    email    varchar(200) references employees (email) on delete cascade,
    password varchar(200) not null
);

insert into employees (first_name, last_name, birthdate, email)
values ('Max', 'Schwarz', '1989-06-10', 'max@test.com');

insert into intranet_accounts (email, password)
values ('max@test.com', 'abc');

drop table intranet_accounts, employees;

create table company_buildings
(
    id   serial primary key,
    name varchar(300) not null
);

create table teams
(
    id          serial primary key,
    name        varchar(300) not null,
    building_id int          references company_buildings on delete set null
);

create table employees
(
    id         serial primary key,
    first_name varchar(300)        not null,
    last_name  varchar(300)        not null,
    birthdate  date                not null,
    email      varchar(200) unique not null,
    team_id    int                 references teams on delete set null
);

create table intranet_accounts
(
    id       serial primary key,
    email    varchar(200) references employees (email) on delete cascade,
    password varchar(200) not null
);

INSERT INTO company_buildings (name)
VALUES ('Main Building'),
       ('Research Lab'),
       ('Darkroom');

INSERT INTO teams (name, building_id)
VALUES ('Admin', 1),
       ('Data Analysts', 3),
       ('R&D', 2);

INSERT INTO employees
    (first_name, last_name, birthdate, email, team_id)
VALUES ('Julie', 'Barnes', '1988-10-01', 'julie@test.com', 3),
       ('Max', 'Schwarz', '1989-06-10', 'max@test.com', 1),
       ('Manuel', 'Lorenz', '1987-01-29', 'manu@test.com', 2);

INSERT INTO intranet_accounts (email, password)
VALUES ('max@test.com', 'abcae1'),
       ('manu@test.com', 'fdasfdas1'),
       ('julie@test.com', 'adsfsaf3');

drop table intranet_accounts, employees, teams, company_buildings;

create table projects
(
    id       serial primary key,
    title    varchar(300) not null,
    deadline date
);

create table company_buildings
(
    id   serial primary key,
    name varchar(300) not null
);

create table teams
(
    id          serial primary key,
    name        varchar(300) not null,
    building_id int          references company_buildings on delete set null
);

create table employees
(
    id         serial primary key,
    first_name varchar(300)        not null,
    last_name  varchar(300)        not null,
    birthdate  date                not null,
    email      varchar(200) unique not null,
    team_id    int                 references teams on delete set null
);

create table intranet_accounts
(
    id       serial primary key,
    email    varchar(200) references employees (email) on delete cascade,
    password varchar(200) not null
);

create table projects_employees
(
    id          serial primary key,
    employee_id int references employees on delete cascade,
    project_id  int references projects on delete cascade
);

INSERT INTO company_buildings (name)
VALUES ('Main Building'),
       ('Research Lab'),
       ('Darkroom');

INSERT INTO teams (name, building_id)
VALUES ('Admin', 1),
       ('Data Analysts', 3),
       ('R&D', 2);

INSERT INTO employees
    (first_name, last_name, birthdate, email, team_id)
VALUES ('Julie', 'Barnes', '1988-10-01', 'julie@test.com', 3),
       ('Max', 'Schwarz', '1989-06-10', 'max@test.com', 1),
       ('Manuel', 'Lorenz', '1987-01-29', 'manu@test.com', 2),
       ('Michael', 'Smith', '1977-05-12', 'michael@test.com', 2);

INSERT INTO intranet_accounts (email, password)
VALUES ('max@test.com', 'abcae1'),
       ('manu@test.com', 'fdasfdas1'),
       ('julie@test.com', 'adsfsaf3'),
       ('michael@test.com', 'adsfsaf3');

INSERT INTO projects (title, deadline)
VALUES ('Mastering SQL', '2024-10-01'),
       ('New Hire Onboarding', '2022-02-28'),
       ('New Course Evaluation', '2022-01-01');

INSERT INTO projects_employees (employee_id, project_id)
VALUES (1, 2),
       (2, 2),
       (1, 3),
       (3, 1),
       (3, 3),
       (2, 3);

select e.first_name, e.last_name, p.title project_title
from employees e
         left join projects_employees pe on e.id = pe.employee_id
         left join projects p on pe.project_id = p.id
order by e.first_name;

drop table company_buildings, employees, intranet_accounts, projects, projects_employees, teams;

create table employees
(
    id            serial primary key,
    first_name    varchar(300) not null,
    last_name     varchar(300) not null,
    supervisor_id int          references employees on delete set null
);

insert into employees (first_name, last_name, supervisor_id)
values ('Julie', 'Barnes', null),
       ('Manuel', 'Lorenz', 1),
       ('Max', 'Schwarz', 2);

select e1.first_name, e1.last_name, e2.first_name supervisor_first_name, e2.last_name supervisor_last_name
from employees as e1
         left join employees as e2 on e1.supervisor_id = e2.id;

create table users
(
    id         serial primary key,
    first_name varchar(300) not null
);
create table users_friends
(
    user_id   int references users on delete cascade,
    friend_id int references users on delete cascade,
    check ( user_id < friend_id ),
    primary key (user_id, friend_id)
);
insert into users (first_name)
values ('Manuel'),
       ('Max'),
       ('Julie');
insert into users_friends (user_id, friend_id)
values (1, 2),
       (1, 3);

create database restaurants;

CREATE TABLE payment_methods
(
    -- for mysql use this code
    -- id INT PRIMARY KEY AUTO_INCREMENT,
    -- for postgresql use this code
    id   SERIAL PRIMARY KEY,
    name VARCHAR(200)
);

CREATE TABLE tables
(
    -- for mysql use this code
    -- id INT PRIMARY KEY AUTO_INCREMENT,
    -- for postgresql use this code
    id        SERIAL PRIMARY KEY,
    num_seats INT,
    category  VARCHAR(200)
);

INSERT INTO payment_methods (name)
VALUES ('Cash'),
       ('Credit Card');

INSERT INTO tables (num_seats,
                    category)
VALUES (2,
        'small'),
       (2,
        'small'),
       (4,
        'medium'),
       (6,
        'large'),
       (8,
        'large');

CREATE TABLE bookings
(
    -- for mysql use this code
    -- id INT PRIMARY KEY AUTO_INCREMENT,
    -- for postgresql use this code
    id            SERIAL PRIMARY KEY,
    booking_date  DATE          NOT NULL,
    num_guests    INT           NOT NULL,
    amount_billed NUMERIC(6, 2) NOT NULL,
    amount_tipped NUMERIC(6, 2),
    payment_id    INT REFERENCES payment_methods,
    table_id      INT REFERENCES tables
);
INSERT INTO bookings (booking_date,
                      num_guests,
                      amount_billed,
                      amount_tipped,
                      payment_id,
                      table_id)
VALUES ('2021-11-04',
        2,
        19.90,
        0.10,
        2,
        1),
       ('2021-11-04',
        1,
        12.90,
        0.00,
        2,
        2),
       ('2021-11-05',
        2,
        15.50,
        NULL,
        1,
        1),
       ('2021-11-05',
        7,
        113.40,
        6.60,
        1,
        5),
       ('2021-11-05',
        6,
        140.90,
        10.10,
        1,
        4),
       ('2021-11-05',
        7,
        98.60,
        1.40,
        1,
        5),
       ('2021-11-05',
        4,
        60.50,
        4.50,
        2,
        3),
       ('2021-11-06',
        5,
        86.10,
        4.90,
        2,
        4),
       ('2021-11-06',
        3,
        49.70,
        5.30,
        2,
        4),
       ('2021-11-06',
        1,
        15.90,
        2.10,
        1,
        2),
       ('2021-11-06',
        7,
        242.60,
        12.40,
        1,
        5),
       ('2021-11-06',
        6,
        180.00,
        20.00,
        1,
        5),
       ('2021-11-06',
        3,
        38.70,
        11.30,
        2,
        3),
       ('2021-11-06',
        2,
        25.60,
        9.40,
        1,
        1),
       ('2021-11-06',
        3,
        60.50,
        14.50,
        1,
        4),
       ('2021-11-07',
        2,
        26.40,
        1.60,
        2,
        1),
       ('2021-11-07',
        2,
        35.50,
        4.50,
        2,
        2),
       ('2021-11-07',
        5,
        101.90,
        NULL,
        1,
        4),
       ('2021-11-07',
        6,
        130.10,
        10,
        1,
        5),
       ('2021-11-08',
        2,
        38.60,
        0.40,
        2,
        2);

select booking_date, sum(num_guests) num_guests
from bookings
group by booking_date;

select p.name, b.booking_date, sum(num_guests) num_guests
from payment_methods as p
         inner join bookings b on p.id = b.payment_id
group by p.name, b.booking_date;

select booking_date, count(booking_date)
from bookings
group by booking_date
having sum(amount_billed) > 30;

select booking_date
from bookings
group by booking_date
having sum(amount_billed) = (select min(daily_sum)
                             from (select sum(amount_billed) daily_sum
                                   from bookings
                                   group by booking_date) daily_table);

select booking_date, amount_tipped, sum(amount_tipped) over ()
from bookings;

select booking_date, amount_tipped, sum(amount_tipped) over (partition by booking_date)
from bookings;

select booking_date, amount_tipped, sum(amount_tipped) over (partition by booking_date order by amount_billed)
from bookings;

select booking_date, amount_tipped, rank() over (partition by booking_date order by amount_tipped desc)
from bookings;

select amount_billed,
       case when amount_billed > 30 then 'Good Day' when amount_billed > 15 then 'Normal Day' else 'Bad Day' end
from bookings;
