-define(LOGID99, {ffffffffffffffffffffffffffffffff, 999999}). %placeholder

%MESSAGE IDs and STATUS CODEs for hello_client
-define(LOGID00, {ec504cee59b245c0861b78ccd936b856, 200400}). %message passing
-define(LOGID01, {d7a051ed5dab4b50afa67ca5fadd6077, 300400}). %message building
-define(LOGID02, {ff6a6c3ae0734a65b2845c39d223b249, 100100}). %client initialization
-define(LOGID03, {bd8b9bc7d0ef48a98f6286c779781985, 101409}). 
-define(LOGID04, {a55b446c103646b2a84543a907c13378, 102409}). 
-define(LOGID05, {b31ad32a76a94d78b866b2e168f9f7d3, 100101}). 
-define(LOGID06, {c2ba31819c384d76966d6bdb0cf02250, 100101}). 
-define(LOGID07, {d406dffdf263429eac4e64b7c52f7276, 201400}). 
-define(LOGID08, {e9f0397b5b814c3abd55f3a474815f6c, 211200}).
-define(LOGID09, {f819220efa73409fa896aaafc0c21d30, 212200}).
-define(LOGID10, {a953af5734984f39b1c26a3541a1f48f, 213200}).
-define(LOGID11, {c2763c7aba514282a48a87dee13e7738, 210400}).
-define(LOGID12, {a887733cce7949f5a1d041441ccdfdfc, 210204}).
-define(LOGID13, {bc9ed80e61cb441c952422c649a3ff3e, 220200}).
-define(LOGID14, {bfde238fb72f420996cb52eaeda474df, 210200}).
-define(LOGID15, {cb4c75e200f74a279ca3373e37eb7f81, 210400}).
-define(LOGID16, {b68c94425c1f40aca74ef33e13eccbfc, 210409}).
-define(LOGID17, {d77a63a5b17c4f0499fc9360083aa7a1, 210202}).
-define(LOGID18, {ef4efe6bb336491990b99cc1113adb85, 221200}).
-define(LOGID19, {e61cd5d46b344504aad275c1f4831f90, 214400}).
-define(LOGID20, {cd035f8d88aa45cca84b67a4227c8cd6, 224400}). %ping timeout
-define(LOGID21, {d330d615c9a84f9dadd4a327fa3ac2fe, 220200}). %

%MESSAGE IDs and SATUS CODEs for hello_handler
-define(LOGID22, {c68287edeaac43fe96f49161eb8f44ba, 101202}). 
-define(LOGID23, {d3496f96a1154dad96e5ec469dda164b, 101200}). 
-define(LOGID24, {e2f93d4effd2479fa7a6291b2c9da1dd, 410500}). 
-define(LOGID25, {fc965b4e012648578c379fe0faae3461, 400200}). 
-define(LOGID26, {a7237645a763489591c1559b7ec586b8, 400202}). 
-define(LOGID27, {aabd551dcc334fe093954d19b4dcc445, 400599}). 
-define(LOGID28, {b9ab6b39134542fdbf0fabd7a88e8a19, 400202}). 
-define(LOGID29, {c457bf8eb8574927bb1285bc32c18aff, 400200}). 
-define(LOGID30, {da812da4d818443a872767687edd47f3, 400202}).
-define(LOGID31, {b3543661a8b2472984874c9c7325fa81, 400202}).
-define(LOGID32, {aeb8bd41d1ed47048e6ea6056cade3ac, 400202}).
-define(LOGID33, {aee0c58903824a139d1b1df028c223d6, 400202}).
-define(LOGID34, {e5c3f22ef32342e4aa701a556291d34c, 400204}).
-define(LOGID35, {f37d8d8df4d74972a71acdcaeeb1ce40, 400500}).
-define(LOGID36, {f834c0541b024187bf6aacde701e0b88, 400500}).

%MESSAGE IDs and SATUS CODEs for hello_router
-define(LOGID37, {aee45db4a0a4465687588331edc8bde4, 500500}).
-define(LOGID38, {cfe782643a4e49a581a94c2ae146e683, 500200}).

%MESSAGE IDs and SATUS CODEs for hello_http_client
-define(LOGID39, {a95801c548ad4f508f315334ff79f199, 100400}).
-define(LOGID40, {eab6276590fc4d84996662f4c13a271a, 211200}).
-define(LOGID41, {a48b0a9d2aaa477494fade8ace87f20f, 211202}).
-define(LOGID42, {d3cbc27eb6ab43f2b2dfc9114c122054, 210400}).

%MESSAGE IDs and SATUS CODEs for hello_zmq_client
-define(LOGID43, {d80498ec152342eba94827f005123d27, 511200}).
-define(LOGID44, {e6fa0b7a7ffb45f29a359eca6776b369, 510200}).
-define(LOGID45, {eafe96b96fb447c59ba19d8452ee16f8, 511202}).

%MESSAGE IDs and SATUS CODEs for hello_htp_listener
-define(LOGID46, {cb26c528ecb2474db3078ca1156ba7ba, 521200}).

%MESSAGE IDs and SATUS CODEs for hello_zmq_listener
-define(LOGID47, {c0ea6cda30b64f10be3db0ee5fdc22d1, 110500}).
-define(LOGID48, {dea8dfd8818e432bb61a64ca88e35a9e, 520500}).
-define(LOGID49, {e849ee8a79b2435394e81b51894a617c, 521202}).

%MESSAGE IDs and SATUS CODEs for hello_metrics
-define(LOGID50, {c0ea6cda30b64f10be3db0ee5fdc22d1, 700500}).

%MESSAGE IDs and SATUS CODEs for hello_registry
-define(LOGID51, {bb0ea6d2b9c74a78afa724889ceee0b5, 610500}).
-define(LOGID52, {da5cd3be4435462dafff47b1bbc34a62, 610501}).
-define(LOGID53, {a3fcdc9a486247d1af5ea679d0f724e9, 610202}).
-define(LOGID54, {bd8ad7e2a04940e8bc4fd7417d2907aa, 600200}).
-define(LOGID55, {ab5f921ed6e7488293241dc27eaf102e, 600500}).
-define(LOGID56, {b5886b31a45d422bb02422aaf072797b, 700202}).
-define(LOGID57, {af5e3e79776642e4851709b58e7ea790, 510400}).

%MESSAGE IDs and SATUS CODEs for hello_service
-define(LOGID58, {eda0efbe7f6d490490e00ae4055629d2, 700500}).

%MESSAGE IDs and SATUS CODEs for hello_supervisor
-define(LOGID59, {a3b473cec1c841d0ada3232fafe8d081, 610500}).
-define(LOGID60, {be1432aa9c074facae66b9d6786de2e5, 610501}).

%MESSAGE IDs and SATUS CODEs for hello_supervisor
-define(LOGID61, {a3b473cec1c841d0ada3232fafe8d081, 610500}).
-define(LOGID62, {be1432aa9c074facae66b9d6786de2e5, 610501}).
-define(LOGID63, {be1432aa9c074facae66b9d6786de2e5, 610501}).