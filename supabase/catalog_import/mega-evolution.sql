-- Katalogimport: Mega Evolution (1 set)
-- Endast katalogdata (lager 0, pris 0) för portfölj/önskelista-funktionen.

-- Set: 30th Celebration: Classic Collection (me55c) -- 2026/09/16
insert into sets (category_slug, category_name, slug, name, is_visible)
  values ('mega-evolution', 'Mega Evolution', '30th-celebration-classic-collection', '30th Celebration: Classic Collection', false)
  on conflict (slug) do nothing;

with s as (select id from sets where slug = '30th-celebration-classic-collection'),
inserted_cards as (
  insert into cards (set_id, number, name, rarity, image_url, pokemon_type)
  select s.id, v.number, v.name, v.rarity, v.image_url, v.pokemon_type
  from s, (values
    (58, 'Pikachu', 'common', 'https://images.scrydex.com/pokemon/me55c-58/large', 'lightning'),
    (4, 'Charizard', 'rare', 'https://images.scrydex.com/pokemon/me55c-4/large', 'fire'),
    (18, 'Misty', 'rare', 'https://images.scrydex.com/pokemon/me55c-18/large', NULL),
    (69, 'Erika''s Jigglypuff', 'common', 'https://images.scrydex.com/pokemon/me55c-69/large', 'colorless'),
    (25, 'Sneasel', 'rare', 'https://images.scrydex.com/pokemon/me55c-25/large', 'darkness'),
    (106, 'Shining Celebi', 'mega_hyper_rare', 'https://images.scrydex.com/pokemon/me55c-106/large', 'grass'),
    (149, 'Lugia', 'mega_hyper_rare', 'https://images.scrydex.com/pokemon/me55c-149/large', 'colorless'),
    (5, 'Delcatty', 'rare', 'https://images.scrydex.com/pokemon/me55c-5/large', 'colorless'),
    (19, 'Dark Tyranitar', 'rare', 'https://images.scrydex.com/pokemon/me55c-19/large', 'darkness'),
    (108, 'Scizor ex', 'double_rare', 'https://images.scrydex.com/pokemon/me55c-108/large', 'metal'),
    (11, 'Metagross', 'rare', 'https://images.scrydex.com/pokemon/me55c-11/large', 'lightning'),
    (107, 'Palkia LV.X', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-106p/large', 'water'),
    (43, 'Uxie', 'rare', 'https://images.scrydex.com/pokemon/me55c-43/large', 'psychic'),
    (47, 'Crobat G', 'common', 'https://images.scrydex.com/pokemon/me55c-47/large', 'psychic'),
    (94, 'Gengar', 'double_rare', 'https://images.scrydex.com/pokemon/me55c-94/large', 'psychic'),
    (99, 'Darkrai & Cresselia LEGEND', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-99/large', 'darkness'),
    (100, 'Darkrai & Cresselia LEGEND', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-100/large', 'darkness'),
    (101, 'N', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-101/large', NULL),
    (85, 'Rayquaza-EX', 'double_rare', 'https://images.scrydex.com/pokemon/me55c-85/large', 'dragon'),
    (12, 'Genesect-EX', 'double_rare', 'https://images.scrydex.com/pokemon/me55c-11g/large', 'grass'),
    (109, 'M Gardevoir-EX', 'double_rare', 'https://images.scrydex.com/pokemon/me55c-106m/large', 'fairy'),
    (41, 'Greninja BREAK', 'double_rare', 'https://images.scrydex.com/pokemon/me55c-41/large', 'water'),
    (89, 'Solgaleo-GX', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-89/large', 'metal'),
    (57, 'Buzzwole-GX', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-57/large', 'fighting'),
    (33, 'Pikachu & Zekrom-GX', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-33/large', 'lightning'),
    (138, 'Zacian V', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-138/large', 'metal'),
    (50, 'Raikou', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-50/large', 'lightning'),
    (114, 'Mew VMAX', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-114/large', 'psychic'),
    (123, 'Arceus VSTAR', 'ultra_rare', 'https://images.scrydex.com/pokemon/me55c-123/large', 'colorless'),
    (203, 'Magikarp', 'illustration_rare', 'https://images.scrydex.com/pokemon/me55c-203/large', 'water')
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
