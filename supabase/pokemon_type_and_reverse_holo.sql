-- Adds two things to the schema, both needed for the admin updates:
--
-- 1) cards.pokemon_type — the energy "färg" (Water, Grass, Fire, …) that
--    Pokémon-korten fysiskt sorteras efter innan de läggs i fack. Nullable,
--    since Topps-kort och Trainer/Energy-kort inte har en typ. Existing
--    cards are left NULL — tagga dem i /admin, sök- och listfältet har
--    fått en ny "Typ"-väljare per kort för det.
--
-- 2) card_variants.variant now also allows 'reverse_holo', alongside the
--    existing 'normal' and 'holo'. The check constraint is dropped and
--    recreated dynamically (its name isn't guaranteed) so this is safe to
--    run whether or not it's already been altered before.
--
-- Safe to run more than once.

alter table cards
  add column if not exists pokemon_type text;

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'cards_pokemon_type_check'
  ) then
    alter table cards
      add constraint cards_pokemon_type_check
      check (
        pokemon_type is null or pokemon_type in (
          'grass', 'fire', 'water', 'lightning', 'psychic',
          'fighting', 'darkness', 'metal', 'fairy', 'dragon', 'colorless'
        )
      );
  end if;
end $$;

create index if not exists idx_cards_pokemon_type on cards(pokemon_type);

-- Widen card_variants.variant to also accept 'reverse_holo'.
do $$
declare
  conname text;
begin
  select con.conname into conname
  from pg_constraint con
  join pg_class rel on rel.oid = con.conrelid
  where rel.relname = 'card_variants'
    and con.contype = 'c'
    and pg_get_constraintdef(con.oid) like '%variant%'
    and pg_get_constraintdef(con.oid) like '%normal%';

  if conname is not null then
    execute format('alter table card_variants drop constraint %I', conname);
  end if;
end $$;

alter table card_variants
  add constraint card_variants_variant_check
  check (variant in ('normal', 'holo', 'reverse_holo'));
