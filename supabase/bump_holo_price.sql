-- One-off price fix: bumps holo variants of "common" rarity cards from the
-- old 2 kr seed default up to 4 kr, across every set already in the
-- database. Safe to run more than once — it only touches holo variants
-- currently priced below 4 kr on common-tier cards, so it won't clobber a
-- price you've already customized to something higher.

update card_variants
set price_sek = 4
from cards
where card_variants.card_id = cards.id
  and card_variants.variant = 'holo'
  and cards.rarity = 'common'
  and card_variants.price_sek < 4;
