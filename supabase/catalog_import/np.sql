-- Katalogimport: NP (1 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: Nintendo Black Star Promos (np) -- 2003/10/01
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('np', 'NP', 'nintendo-black-star-promos', 'Nintendo Black Star Promos', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = 'nintendo-black-star-promos'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (1, 'Kyogre ex', 'promo', 'https://images.pokemontcg.io/np/1_hires.png', 'water'),
    (2, 'Groudon ex', 'promo', 'https://images.pokemontcg.io/np/2_hires.png', 'fighting'),
    (3, 'Treecko', 'promo', 'https://images.pokemontcg.io/np/3_hires.png', 'grass'),
    (4, 'Grovyle', 'promo', 'https://images.pokemontcg.io/np/4_hires.png', 'grass'),
    (5, 'Mudkip', 'promo', 'https://images.pokemontcg.io/np/5_hires.png', 'water'),
    (6, 'Torchic', 'promo', 'https://images.pokemontcg.io/np/6_hires.png', 'fire'),
    (7, 'Treecko', 'promo', 'https://images.pokemontcg.io/np/7_hires.png', 'grass'),
    (8, 'Torchic', 'promo', 'https://images.pokemontcg.io/np/8_hires.png', 'fire'),
    (9, 'Combusken', 'promo', 'https://images.pokemontcg.io/np/9_hires.png', 'fire'),
    (10, 'Mudkip', 'promo', 'https://images.pokemontcg.io/np/10_hires.png', 'water'),
    (11, 'Marshtomp', 'promo', 'https://images.pokemontcg.io/np/11_hires.png', 'water'),
    (12, 'Pikachu', 'promo', 'https://images.pokemontcg.io/np/12_hires.png', 'lightning'),
    (13, 'Meowth', 'promo', 'https://images.pokemontcg.io/np/13_hires.png', 'colorless'),
    (14, 'Latias', 'promo', 'https://images.pokemontcg.io/np/14_hires.png', 'colorless'),
    (15, 'Latios', 'promo', 'https://images.pokemontcg.io/np/15_hires.png', 'colorless'),
    (16, 'Treecko', 'promo', 'https://images.pokemontcg.io/np/16_hires.png', 'grass'),
    (17, 'Torchic', 'promo', 'https://images.pokemontcg.io/np/17_hires.png', 'fire'),
    (18, 'Mudkip', 'promo', 'https://images.pokemontcg.io/np/18_hires.png', 'water'),
    (19, 'Whismur', 'promo', 'https://images.pokemontcg.io/np/19_hires.png', 'colorless'),
    (20, 'Ludicolo', 'promo', 'https://images.pokemontcg.io/np/20_hires.png', 'water'),
    (21, 'Jirachi', 'promo', 'https://images.pokemontcg.io/np/21_hires.png', 'psychic'),
    (22, 'Beldum', 'promo', 'https://images.pokemontcg.io/np/22_hires.png', 'metal'),
    (23, 'Metang', 'promo', 'https://images.pokemontcg.io/np/23_hires.png', 'metal'),
    (24, 'Chimecho', 'promo', 'https://images.pokemontcg.io/np/24_hires.png', 'psychic'),
    (25, 'Flygon', 'promo', 'https://images.pokemontcg.io/np/25_hires.png', 'colorless'),
    (26, 'Tropical Wind', 'promo', 'https://images.pokemontcg.io/np/26_hires.png', NULL),
    (27, 'Tropical Tidal Wave', 'promo', 'https://images.pokemontcg.io/np/27_hires.png', NULL),
    (28, 'Championship Arena', 'promo', 'https://images.pokemontcg.io/np/28_hires.png', NULL),
    (29, 'Celebi', 'promo', 'https://images.pokemontcg.io/np/29_hires.png', 'grass'),
    (30, 'Suicune', 'promo', 'https://images.pokemontcg.io/np/30_hires.png', 'water'),
    (31, 'Moltres ex', 'promo', 'https://images.pokemontcg.io/np/31_hires.png', 'fire'),
    (32, 'Articuno ex', 'promo', 'https://images.pokemontcg.io/np/32_hires.png', 'water'),
    (33, 'Zapdos ex', 'promo', 'https://images.pokemontcg.io/np/33_hires.png', 'lightning'),
    (34, 'Typhlosion', 'promo', 'https://images.pokemontcg.io/np/34_hires.png', 'fire'),
    (35, 'Pikachu δ', 'promo', 'https://images.pokemontcg.io/np/35_hires.png', 'metal'),
    (36, 'Tropical Tidal Wave', 'promo', 'https://images.pokemontcg.io/np/36_hires.png', NULL),
    (37, 'Kyogre ex', 'promo', 'https://images.pokemontcg.io/np/37_hires.png', 'water'),
    (38, 'Groudon ex', 'promo', 'https://images.pokemontcg.io/np/38_hires.png', 'fighting'),
    (39, 'Rayquaza ex', 'promo', 'https://images.pokemontcg.io/np/39_hires.png', 'colorless'),
    (40, 'Mew', 'promo', 'https://images.pokemontcg.io/np/40_hires.png', 'psychic')
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
