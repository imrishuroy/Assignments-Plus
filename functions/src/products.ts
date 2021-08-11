export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export const productDataMap: { [productId: string]: ProductData } = {
  "consumable_product": {
    productId: "consumable_product",
    type: "NON_SUBSCRIPTION",
  },
  "non_consumable": {
    productId: "non_consumable",
    type: "NON_SUBSCRIPTION",
  },
  "subscription": {
    productId: "subscription",
    type: "SUBSCRIPTION",
  },
};
