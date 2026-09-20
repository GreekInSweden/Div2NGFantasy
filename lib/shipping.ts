// Shipping calculation based on number of cards ordered.
//
// UPDATE (2026-09): switched to DHL's small-parcel tier, which covers up
// to 1 kg for 73 kr — comfortably covers essentially any card order by
// weight, and DHL's parcel dimensions are more forgiving for rigid
// packaging (toploaders, cardboard) than PostNord's letter-format tiers
// were, which is what caused the earlier 107 kr surprise.
const FLAT_RATE_SEK = 73;

export function calculateShippingSek(totalCardCount: number): number {
  if (totalCardCount <= 0) return 0;
  return FLAT_RATE_SEK;
}
