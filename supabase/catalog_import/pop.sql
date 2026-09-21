-- Katalogimport: POP (9 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: POP Series 1 (pop1) -- 2004/09/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-1', 'POP Series 1', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-1'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Blaziken', 'rare', 'https://images.pokemontcg.io/pop1/1_hires.png', 'fire'),
    (2, 'Metagross', 'rare', 'https://images.pokemontcg.io/pop1/2_hires.png', 'metal'),
    (3, 'Rayquaza', 'rare', 'https://images.pokemontcg.io/pop1/3_hires.png', 'colorless'),
    (4, 'Sceptile', 'rare', 'https://images.pokemontcg.io/pop1/4_hires.png', 'grass'),
    (5, 'Swampert', 'rare', 'https://images.pokemontcg.io/pop1/5_hires.png', 'water'),
    (6, 'Beautifly', 'common', 'https://images.pokemontcg.io/pop1/6_hires.png', 'grass'),
    (7, 'Masquerain', 'common', 'https://images.pokemontcg.io/pop1/7_hires.png', 'grass'),
    (8, 'Murkrow', 'common', 'https://images.pokemontcg.io/pop1/8_hires.png', 'darkness'),
    (9, 'Pupitar', 'common', 'https://images.pokemontcg.io/pop1/9_hires.png', 'fighting'),
    (10, 'Torkoal', 'common', 'https://images.pokemontcg.io/pop1/10_hires.png', 'fighting'),
    (11, 'Larvitar', 'common', 'https://images.pokemontcg.io/pop1/11_hires.png', 'fighting'),
    (12, 'Minun', 'common', 'https://images.pokemontcg.io/pop1/12_hires.png', 'lightning'),
    (13, 'Plusle', 'common', 'https://images.pokemontcg.io/pop1/13_hires.png', 'lightning'),
    (14, 'Surskit', 'common', 'https://images.pokemontcg.io/pop1/14_hires.png', 'water'),
    (15, 'Swellow', 'common', 'https://images.pokemontcg.io/pop1/15_hires.png', 'colorless'),
    (16, 'Armaldo ex', 'rare', 'https://images.pokemontcg.io/pop1/16_hires.png', 'fighting'),
    (17, 'Tyranitar ex', 'rare', 'https://images.pokemontcg.io/pop1/17_hires.png', 'darkness')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 2 (pop2) -- 2005/08/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-2', 'POP Series 2', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-2'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Entei', 'rare', 'https://images.pokemontcg.io/pop2/1_hires.png', 'fire'),
    (2, 'Pidgeot', 'rare', 'https://images.pokemontcg.io/pop2/2_hires.png', 'colorless'),
    (3, 'Raikou', 'rare', 'https://images.pokemontcg.io/pop2/3_hires.png', 'lightning'),
    (4, 'Suicune', 'rare', 'https://images.pokemontcg.io/pop2/4_hires.png', 'water'),
    (5, 'Tauros', 'rare', 'https://images.pokemontcg.io/pop2/5_hires.png', 'colorless'),
    (6, 'Venusaur', 'rare', 'https://images.pokemontcg.io/pop2/6_hires.png', 'grass'),
    (7, 'Ivysaur', 'common', 'https://images.pokemontcg.io/pop2/7_hires.png', 'grass'),
    (8, 'Mr. Briney''s Compassion', 'common', 'https://images.pokemontcg.io/pop2/8_hires.png', NULL),
    (9, 'Multi Technical Machine 01', 'common', 'https://images.pokemontcg.io/pop2/9_hires.png', NULL),
    (10, 'Pokémon Park', 'common', 'https://images.pokemontcg.io/pop2/10_hires.png', NULL),
    (11, 'TV Reporter', 'common', 'https://images.pokemontcg.io/pop2/11_hires.png', NULL),
    (12, 'Bulbasaur', 'common', 'https://images.pokemontcg.io/pop2/12_hires.png', 'grass'),
    (13, 'Cacnea', 'common', 'https://images.pokemontcg.io/pop2/13_hires.png', 'grass'),
    (14, 'Luvdisc', 'common', 'https://images.pokemontcg.io/pop2/14_hires.png', 'water'),
    (15, 'Phanpy', 'common', 'https://images.pokemontcg.io/pop2/15_hires.png', 'fighting'),
    (16, 'Pikachu', 'common', 'https://images.pokemontcg.io/pop2/16_hires.png', 'lightning'),
    (17, 'Celebi ex', 'rare', 'https://images.pokemontcg.io/pop2/17_hires.png', 'psychic')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 3 (pop3) -- 2006/04/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-3', 'POP Series 3', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-3'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Blastoise', 'rare', 'https://images.pokemontcg.io/pop3/1_hires.png', 'water'),
    (2, 'Flareon', 'rare', 'https://images.pokemontcg.io/pop3/2_hires.png', 'fire'),
    (3, 'Jolteon', 'rare', 'https://images.pokemontcg.io/pop3/3_hires.png', 'lightning'),
    (4, 'Minun', 'rare', 'https://images.pokemontcg.io/pop3/4_hires.png', 'lightning'),
    (5, 'Plusle', 'rare', 'https://images.pokemontcg.io/pop3/5_hires.png', 'lightning'),
    (6, 'Vaporeon', 'rare', 'https://images.pokemontcg.io/pop3/6_hires.png', 'water'),
    (7, 'Combusken', 'common', 'https://images.pokemontcg.io/pop3/7_hires.png', 'fire'),
    (8, 'Donphan', 'common', 'https://images.pokemontcg.io/pop3/8_hires.png', 'fighting'),
    (9, 'Forretress', 'common', 'https://images.pokemontcg.io/pop3/9_hires.png', 'grass'),
    (10, 'High Pressure System', 'common', 'https://images.pokemontcg.io/pop3/10_hires.png', NULL),
    (11, 'Low Pressure System', 'common', 'https://images.pokemontcg.io/pop3/11_hires.png', NULL),
    (12, 'Ditto', 'common', 'https://images.pokemontcg.io/pop3/12_hires.png', 'psychic'),
    (13, 'Eevee', 'common', 'https://images.pokemontcg.io/pop3/13_hires.png', 'colorless'),
    (14, 'Ivysaur', 'common', 'https://images.pokemontcg.io/pop3/14_hires.png', 'grass'),
    (15, 'Marshtomp', 'common', 'https://images.pokemontcg.io/pop3/15_hires.png', 'fighting'),
    (16, 'Pichu Bros.', 'common', 'https://images.pokemontcg.io/pop3/16_hires.png', 'lightning'),
    (17, 'Ho-Oh ex', 'rare', 'https://images.pokemontcg.io/pop3/17_hires.png', 'fire')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 4 (pop4) -- 2006/08/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-4', 'POP Series 4', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-4'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Chimecho δ', 'rare', 'https://images.pokemontcg.io/pop4/1_hires.png', 'metal'),
    (2, 'Deoxys δ', 'rare', 'https://images.pokemontcg.io/pop4/2_hires.png', 'colorless'),
    (3, 'Flygon', 'rare', 'https://images.pokemontcg.io/pop4/3_hires.png', 'fighting'),
    (4, 'Mew', 'rare', 'https://images.pokemontcg.io/pop4/4_hires.png', 'psychic'),
    (5, 'Sceptile', 'rare', 'https://images.pokemontcg.io/pop4/5_hires.png', 'grass'),
    (6, 'Combusken', 'common', 'https://images.pokemontcg.io/pop4/6_hires.png', 'fire'),
    (7, 'Grovyle', 'common', 'https://images.pokemontcg.io/pop4/7_hires.png', 'grass'),
    (8, 'Heal Energy', 'common', 'https://images.pokemontcg.io/pop4/8_hires.png', NULL),
    (9, 'Pokémon Fan Club', 'common', 'https://images.pokemontcg.io/pop4/9_hires.png', NULL),
    (10, 'Scramble Energy', 'common', 'https://images.pokemontcg.io/pop4/10_hires.png', NULL),
    (11, 'Mudkip', 'common', 'https://images.pokemontcg.io/pop4/11_hires.png', 'water'),
    (12, 'Pidgey', 'common', 'https://images.pokemontcg.io/pop4/12_hires.png', 'colorless'),
    (13, 'Pikachu', 'common', 'https://images.pokemontcg.io/pop4/13_hires.png', 'lightning'),
    (14, 'Squirtle', 'common', 'https://images.pokemontcg.io/pop4/14_hires.png', 'water'),
    (15, 'Treecko δ', 'common', 'https://images.pokemontcg.io/pop4/15_hires.png', 'psychic'),
    (16, 'Wobbuffet', 'common', 'https://images.pokemontcg.io/pop4/16_hires.png', 'psychic'),
    (17, 'Deoxys ex', 'rare', 'https://images.pokemontcg.io/pop4/17_hires.png', 'psychic')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 5 (pop5) -- 2007/03/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-5', 'POP Series 5', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-5'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Ho-Oh', 'rare', 'https://images.pokemontcg.io/pop5/1_hires.png', 'fire'),
    (2, 'Lugia', 'rare', 'https://images.pokemontcg.io/pop5/2_hires.png', 'psychic'),
    (3, 'Mew δ', 'rare', 'https://images.pokemontcg.io/pop5/3_hires.png', 'fire'),
    (4, 'Double Rainbow Energy', 'rare', 'https://images.pokemontcg.io/pop5/4_hires.png', NULL),
    (5, 'Charmeleon δ', 'common', 'https://images.pokemontcg.io/pop5/5_hires.png', 'lightning'),
    (6, 'Bill''s Maintenance', 'common', 'https://images.pokemontcg.io/pop5/6_hires.png', NULL),
    (7, 'Rare Candy', 'common', 'https://images.pokemontcg.io/pop5/7_hires.png', NULL),
    (8, 'Boost Energy', 'common', 'https://images.pokemontcg.io/pop5/8_hires.png', NULL),
    (9, 'δ Rainbow Energy', 'common', 'https://images.pokemontcg.io/pop5/9_hires.png', NULL),
    (10, 'Charmander δ', 'common', 'https://images.pokemontcg.io/pop5/10_hires.png', 'lightning'),
    (11, 'Meowth δ', 'common', 'https://images.pokemontcg.io/pop5/11_hires.png', 'darkness'),
    (12, 'Pikachu', 'common', 'https://images.pokemontcg.io/pop5/12_hires.png', 'lightning'),
    (13, 'Pikachu δ', 'common', 'https://images.pokemontcg.io/pop5/13_hires.png', 'metal'),
    (14, 'Pelipper δ', 'common', 'https://images.pokemontcg.io/pop5/14_hires.png', 'lightning'),
    (15, 'Zangoose δ', 'common', 'https://images.pokemontcg.io/pop5/15_hires.png', 'metal'),
    (16, 'Espeon ★', 'rare', 'https://images.pokemontcg.io/pop5/16_hires.png', 'psychic'),
    (17, 'Umbreon ★', 'rare', 'https://images.pokemontcg.io/pop5/17_hires.png', 'darkness')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 6 (pop6) -- 2007/09/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-6', 'POP Series 6', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-6'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Bastiodon', 'rare', 'https://images.pokemontcg.io/pop6/1_hires.png', 'metal'),
    (2, 'Lucario', 'rare', 'https://images.pokemontcg.io/pop6/2_hires.png', 'fighting'),
    (3, 'Manaphy', 'rare', 'https://images.pokemontcg.io/pop6/3_hires.png', 'water'),
    (4, 'Pachirisu', 'rare', 'https://images.pokemontcg.io/pop6/4_hires.png', 'lightning'),
    (5, 'Rampardos', 'rare', 'https://images.pokemontcg.io/pop6/5_hires.png', 'fighting'),
    (6, 'Drifloon', 'common', 'https://images.pokemontcg.io/pop6/6_hires.png', 'psychic'),
    (7, 'Gible', 'common', 'https://images.pokemontcg.io/pop6/7_hires.png', 'colorless'),
    (8, 'Riolu', 'common', 'https://images.pokemontcg.io/pop6/8_hires.png', 'fighting'),
    (9, 'Pikachu', 'common', 'https://images.pokemontcg.io/pop6/9_hires.png', 'lightning'),
    (10, 'Staravia', 'common', 'https://images.pokemontcg.io/pop6/10_hires.png', 'colorless'),
    (11, 'Bidoof', 'common', 'https://images.pokemontcg.io/pop6/11_hires.png', 'colorless'),
    (12, 'Buneary', 'common', 'https://images.pokemontcg.io/pop6/12_hires.png', 'colorless'),
    (13, 'Cherubi', 'common', 'https://images.pokemontcg.io/pop6/13_hires.png', 'grass'),
    (14, 'Chimchar', 'common', 'https://images.pokemontcg.io/pop6/14_hires.png', 'fire'),
    (15, 'Piplup', 'common', 'https://images.pokemontcg.io/pop6/15_hires.png', 'water'),
    (16, 'Starly', 'common', 'https://images.pokemontcg.io/pop6/16_hires.png', 'colorless'),
    (17, 'Turtwig', 'common', 'https://images.pokemontcg.io/pop6/17_hires.png', 'grass')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 7 (pop7) -- 2008/03/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-7', 'POP Series 7', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-7'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Ampharos', 'rare', 'https://images.pokemontcg.io/pop7/1_hires.png', 'lightning'),
    (2, 'Gallade', 'rare', 'https://images.pokemontcg.io/pop7/2_hires.png', 'fighting'),
    (3, 'Latias', 'rare', 'https://images.pokemontcg.io/pop7/3_hires.png', 'colorless'),
    (4, 'Latios', 'rare', 'https://images.pokemontcg.io/pop7/4_hires.png', 'colorless'),
    (5, 'Mothim', 'rare', 'https://images.pokemontcg.io/pop7/5_hires.png', 'grass'),
    (6, 'Delibird', 'common', 'https://images.pokemontcg.io/pop7/6_hires.png', 'water'),
    (7, 'Flaaffy', 'common', 'https://images.pokemontcg.io/pop7/7_hires.png', 'lightning'),
    (8, 'Kirlia', 'common', 'https://images.pokemontcg.io/pop7/8_hires.png', 'psychic'),
    (9, 'Stantler', 'common', 'https://images.pokemontcg.io/pop7/9_hires.png', 'colorless'),
    (10, 'Wormadam Sandy Cloak', 'common', 'https://images.pokemontcg.io/pop7/10_hires.png', 'fighting'),
    (11, 'Burmy Plant Cloak', 'common', 'https://images.pokemontcg.io/pop7/11_hires.png', 'grass'),
    (12, 'Burmy Sandy Cloak', 'common', 'https://images.pokemontcg.io/pop7/12_hires.png', 'grass'),
    (13, 'Corsola', 'common', 'https://images.pokemontcg.io/pop7/13_hires.png', 'water'),
    (14, 'Mareep', 'common', 'https://images.pokemontcg.io/pop7/14_hires.png', 'lightning'),
    (15, 'Ralts', 'common', 'https://images.pokemontcg.io/pop7/15_hires.png', 'psychic'),
    (16, 'Sentret', 'common', 'https://images.pokemontcg.io/pop7/16_hires.png', 'colorless'),
    (17, 'Spinda', 'common', 'https://images.pokemontcg.io/pop7/17_hires.png', 'colorless')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 8 (pop8) -- 2008/09/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-8', 'POP Series 8', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-8'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Heatran', 'rare', 'https://images.pokemontcg.io/pop8/1_hires.png', 'fire'),
    (2, 'Lucario', 'rare', 'https://images.pokemontcg.io/pop8/2_hires.png', 'fighting'),
    (3, 'Luxray', 'rare', 'https://images.pokemontcg.io/pop8/3_hires.png', 'lightning'),
    (4, 'Probopass', 'rare', 'https://images.pokemontcg.io/pop8/4_hires.png', 'metal'),
    (5, 'Yanmega', 'rare', 'https://images.pokemontcg.io/pop8/5_hires.png', 'grass'),
    (6, 'Cherrim', 'common', 'https://images.pokemontcg.io/pop8/6_hires.png', 'grass'),
    (7, 'Carnivine', 'common', 'https://images.pokemontcg.io/pop8/7_hires.png', 'grass'),
    (8, 'Luxio', 'common', 'https://images.pokemontcg.io/pop8/8_hires.png', 'lightning'),
    (9, 'Night Maintenance', 'common', 'https://images.pokemontcg.io/pop8/9_hires.png', NULL),
    (10, 'Rare Candy', 'common', 'https://images.pokemontcg.io/pop8/10_hires.png', NULL),
    (11, 'Roseanne''s Research', 'common', 'https://images.pokemontcg.io/pop8/11_hires.png', NULL),
    (12, 'Chimchar', 'common', 'https://images.pokemontcg.io/pop8/12_hires.png', 'fire'),
    (13, 'Croagunk', 'common', 'https://images.pokemontcg.io/pop8/13_hires.png', 'psychic'),
    (14, 'Happiny', 'common', 'https://images.pokemontcg.io/pop8/14_hires.png', 'colorless'),
    (15, 'Piplup', 'common', 'https://images.pokemontcg.io/pop8/15_hires.png', 'water'),
    (16, 'Riolu', 'common', 'https://images.pokemontcg.io/pop8/16_hires.png', 'fighting'),
    (17, 'Turtwig', 'common', 'https://images.pokemontcg.io/pop8/17_hires.png', 'grass')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;

-- Set: POP Series 9 (pop9) -- 2009/03/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('pop', 'POP', 'pop-series-9', 'POP Series 9', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'pop-series-9'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Garchomp', 'rare', 'https://images.pokemontcg.io/pop9/1_hires.png', 'colorless'),
    (2, 'Manaphy', 'rare', 'https://images.pokemontcg.io/pop9/2_hires.png', 'water'),
    (3, 'Raichu', 'rare', 'https://images.pokemontcg.io/pop9/3_hires.png', 'lightning'),
    (4, 'Regigigas', 'rare', 'https://images.pokemontcg.io/pop9/4_hires.png', 'colorless'),
    (5, 'Rotom', 'rare', 'https://images.pokemontcg.io/pop9/5_hires.png', 'lightning'),
    (6, 'Buizel', 'common', 'https://images.pokemontcg.io/pop9/6_hires.png', 'water'),
    (7, 'Croagunk', 'common', 'https://images.pokemontcg.io/pop9/7_hires.png', 'psychic'),
    (8, 'Gabite', 'common', 'https://images.pokemontcg.io/pop9/8_hires.png', 'colorless'),
    (9, 'Lopunny', 'common', 'https://images.pokemontcg.io/pop9/9_hires.png', 'colorless'),
    (10, 'Pachirisu', 'common', 'https://images.pokemontcg.io/pop9/10_hires.png', 'lightning'),
    (11, 'Pichu', 'common', 'https://images.pokemontcg.io/pop9/11_hires.png', 'lightning'),
    (12, 'Buneary', 'common', 'https://images.pokemontcg.io/pop9/12_hires.png', 'colorless'),
    (13, 'Chimchar', 'common', 'https://images.pokemontcg.io/pop9/13_hires.png', 'fire'),
    (14, 'Gible', 'common', 'https://images.pokemontcg.io/pop9/14_hires.png', 'colorless'),
    (15, 'Pikachu', 'common', 'https://images.pokemontcg.io/pop9/15_hires.png', 'lightning'),
    (16, 'Piplup', 'common', 'https://images.pokemontcg.io/pop9/16_hires.png', 'water'),
    (17, 'Turtwig', 'common', 'https://images.pokemontcg.io/pop9/17_hires.png', 'grass')
  ) as v(number, name, rarity, image_url, pokemon_type)
  on conflict (set_id, number) do nothing
  returning id, rarity
)
insert into card_variants (card_id, variant, price_sek, stock)
select ic.id, x.variant, 0, 0
from inserted_cards ic
cross join lateral (
  select case when ic.rarity = 'rare' then 'holo' else 'normal' end as variant
  union all
  select 'reverse_holo' where ic.rarity in ('common','rare')
) as x(variant)
on conflict (card_id, variant) do nothing;
