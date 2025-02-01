import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can create new route",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("stepnest-core", "create-route", [
        types.utf8("Test Route"),
        types.utf8("Test Description"),
        types.uint(3),
        types.uint(5000),
        types.list([
          types.tuple({
            lat: types.int(51507222),
            lng: types.int(-1127777)
          })
        ])
      ], wallet_1.address)
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    const [receipt] = block.receipts;
    receipt.result.expectOk().expectUint(1);
  },
});

Clarinet.test({
  name: "Can like a route",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("stepnest-social", "like-route", [
        types.uint(1)
      ], wallet_1.address)
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    
    const [receipt] = block.receipts;
    receipt.result.expectOk().expectBool(true);
  },
});
