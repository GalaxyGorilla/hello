### Logging in hello

This document describes the status codes used in hello. Status codes should be seen in logging as a 6-digit number prepended to the actual log message. The first 3 digits describe an abstract logging class while the last 3 digits are aligned to http status codes and define the logging statement more precisely.

| Logging Class                             | ID  |
|-------------------------------------------| --- |
| Initialization (client)                   | 100 |
| Initialization (server)                   | 110 |
| Client message passing (client)           | 200 |
| Client message passing (server)           | 210 |
| Message creation and parsing (client)     | 300 |
| Message creation and parsing (server)     | 310 |
| Routing (server only)                     | 400 |
| Metrics                                   | 500 |

##### The following list will describe each used status code. The message and explanation part are unique for the specific last 3 digits of the status code. For every possible message a UUID was generated which can be used to identify a message in journal files.

#### 200400

* ___Messages___: 
  * [ec504cee59b245c0861b78ccd936b856] Request from hello client @Client@ failed with reason @REASON@.
  * [cb4c75e200f74a279ca3373e37eb7f81] Hello client @CLIENT attempted to send binary request but failed with reason @REASON@.
* ___Explanation___: Hello client attempted to send a request but failed due to issues with encoding or transport specific reasons.
* ___Level___: info

#### 300400

* ___Messages___: 
  * [d7a051ed5dab4b50afa67ca5fadd6077] Creation of request from hello client @Client@ failed for a call with reason @REASON@.
  * [b68c94425c1f40aca74ef33e13eccbfc] Hello client @CLIENT@ attempted to encode request but failed with reason @REASON@.
* ___Explanation___: Hello client attempted to create a request but failed due to protocol specific reasons.
* ___Level___: info

#### 300401

* ___Messages___: 
  * [c2763c7aba514282a48a87dee13e7738] Hello client @CLIENT@ failed to decode response with reason @REASON@.
* ___Explanation___: Hello client attempted to decode a response but failed due to issues with the protocol specific creation process.
* ___Level___: info

#### 300202

* ___Messages___: 
  * [d77a63a5b17c4f0499fc9360083aa7a1] Hello client @CLIENT@ attempted to encode request but ignored sending request.
* ___Explanation___: Hello client attempted to encode or decode a response but ignored further processing.
* ___Level___: debug


#### 100200

* ___Messages___: 
  * [ff6a6c3ae0734a65b2845c39d223b249] Initializing hello client @Client@ on @URL@ ...
  * [b31ad32a76a94d78b866b2e168f9f7d3] Hello client @Client@ initialized successfully.
  * [c2ba31819c384d76966d6bdb0cf02250] Hello client @Client@ initialized successfully with keep alive.
* ___Explanation___: Hello client initializing process. Protocol and transport state are initialized.
* ___Level___: debug

#### 100400

* ___Messages___: 
  * [bd8b9bc7d0ef48a98f6286c779781985] Hello client @Client@ is unable to initialize protocol because of reason @REASON@.
  * [a55b446c103646b2a84543a907c13378] Hello client @CLIENT@ unable to initialize transport because of reason @REASON@.
* ___Explanation___: Hello client protocol or transport handler returned an error reason @REASON@.
* ___Level___: info

#### 200200

* ___Messages___: 
  * [e9f0397b5b814c3abd55f3a474815f6c] Hello client @CLIENT@ received notification.
  * [f819220efa73409fa896aaafc0c21d30] Hello client @CLIENT@ received single response.
  * [a953af5734984f39b1c26a3541a1f48f] Hello client @CLIENT@ received batch response.
  * [bfde238fb72f420996cb52eaeda474df] Hello client @CLIENT@ sent request.
* ___Explanation___: The client sent or received a response on a request.
* ___Level___: debug

#### 200201

* ___Messages___: 
  * [bc9ed80e61cb441c952422c649a3ff3e] Hello client @CLIENT@ received internal message.
  * [d330d615c9a84f9dadd4a327fa3ac2fe] Hello client @CLIENT@ sent PING request. Pinging server again in @TIME@ milliseconds.
  * [ef4efe6bb336491990b99cc1113adb85] Hello client @CLIENT@ received PONG response. Pinging server again in @TIME@ milliseconds.
* ___Explanation___: The client sent or received a message for e.g. informational purposes. This does affect functionality of the client, e.g. keep alive mechanisms or similar.
* ___Level___: debug

#### 200202

* ___Messages___: 
  * [d406dffdf263429eac4e64b7c52f7276] Hello client @CLIENT@ received error notification from transport handler with reason @REASON@.
  * [a887733cce7949f5a1d041441ccdfdfc] Hello client @CLIENT@ ignored decoding binary response.
  * [e61cd5d46b344504aad275c1f4831f90] Hello client @CLIENT@ got response for non-existing request id @ID@.
* ___Explanation___: The client sent or received a message for e.g. informational purposes. This does not affect functionality of the client.
* ___Level___: debug

#### 200401

* ___Messages___: 
  * [cd035f8d88aa45cca84b67a4227c8cd6] Error in hello client @CLIENT@: There is no PONG answer on PING for @TIME@ msec. Connection will be reestablished.
* ___Explanation___: The client sent or received an error message for e.g. informational purposes. This does affect functionality of the client.
* ___Level___: debug