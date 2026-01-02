// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 1605867253348873044410744649914060210215923252500590430425042094577426465530;
    uint256 constant alphay  = 6734659016482527664401082477225499025623239139918529667417137308969842801810;
    uint256 constant betax1  = 4879143007897952123918086796029367008106797717966349487362404108401427667885;
    uint256 constant betax2  = 11808664967943554024430579345842976561373409471113344679699651641697895020423;
    uint256 constant betay1  = 4289472362645385578569672035529961010107306642405017890830729251861641758133;
    uint256 constant betay2  = 19825609866515889677441401346969415075952990175855870772318705493794122847330;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 12807696906388375277687130362799453230260193124482979786328887166957707432692;
    uint256 constant deltax2 = 19850269676896950221029708835484987363952964426943880903818322013033905580896;
    uint256 constant deltay1 = 19905630367711913906274129978347326237775572356896379340341888620679937853286;
    uint256 constant deltay2 = 20952274409141844836786220013823349194863673560564033122180783264256033416792;

    
    uint256 constant IC0x = 12588616125461605626825271878945099320982766227531255996033988860056021759071;
    uint256 constant IC0y = 3982960021731653162186735089408067028199882058834787021808539500697818530390;
    
    uint256 constant IC1x = 12065284600834571881325925518668094842262841714700568521148058316615136680788;
    uint256 constant IC1y = 14566034053400900244106246106118215846141135797057273386352158335347034088685;
    
    uint256 constant IC2x = 13909179903311625574129548708611662383236442621537402496237072981644944079425;
    uint256 constant IC2y = 15094904917757252666756767897621724773101588791762293767852093174505964428736;
    
    uint256 constant IC3x = 11228522123134791357638091777621504998501341041490379656369122539701689253743;
    uint256 constant IC3y = 2283586201324116808581005683175887362736899005482452841346144107790861230353;
    
    uint256 constant IC4x = 13372253628318429488755624948889865671454366745376730138283286459452250046774;
    uint256 constant IC4y = 7706264322693010717900633577569651816822310433755030405777543383663817898450;
    
    uint256 constant IC5x = 15133193357924805035899638585240789288184792875173794718478753755529517100428;
    uint256 constant IC5y = 13933385980996619369895695087366118909468304229562022805229719606409847188983;
    
    uint256 constant IC6x = 6547126315857714463231270278656723757732700512766735151186215139825935834026;
    uint256 constant IC6y = 19519896476657195891881351553551131277798370334922388412393147503541002026043;
    
    uint256 constant IC7x = 8937513617943522536044519794491805133836912088408298213283862278119255300468;
    uint256 constant IC7y = 3851947815271671262304546379653010941290820222721186350917718347805905494706;
    
    uint256 constant IC8x = 21495181193963778280029227393585250345614670365481298303200292613452756741267;
    uint256 constant IC8y = 19943545612200775785033173565846567766492127012920696136876005104295020473413;
    
    uint256 constant IC9x = 11877040178069235473367712567107208319609699637389183130634042362459718558280;
    uint256 constant IC9y = 5064971730007090565596856913043868494660173550155371170911895397621583281808;
    
    uint256 constant IC10x = 21373908570607793170536126706575662414960219794362268394408653019208231743245;
    uint256 constant IC10y = 18837871070065760224570664886630477071796311164950389201023352736558030330612;
    
    uint256 constant IC11x = 8231097241506043704668536996866580547487282150345849937580640159091445606981;
    uint256 constant IC11y = 8274497845482963936324482697130267893966158820604811516533322335806522199478;
    
    uint256 constant IC12x = 8988822754370979150707751730955113892425709568599487341194034273039348805405;
    uint256 constant IC12y = 769784684347904106848365428610285779810072450398601224382294326712346982042;
    
    uint256 constant IC13x = 8360666694631628863959660689567998612616898191495298837086596232782702500377;
    uint256 constant IC13y = 11227298074071215112690867041083643092092027881237479026990841999786540437739;
    
    uint256 constant IC14x = 12197855701874142879989496927442691289062681194508860739004117829960337711726;
    uint256 constant IC14y = 7332724252356735189259972534039268365576981837537519363849192248415056672032;
    
    uint256 constant IC15x = 97344063360698422384564055882974837406128496181724808087828472307648980289;
    uint256 constant IC15y = 9813973884252895381420127775912016319124393092363182274794986168848835087884;
    
    uint256 constant IC16x = 21154986731683523219217445373496237046427491153488266106616371924115083847522;
    uint256 constant IC16y = 18075855588341409177243841156908838670456339455453437002158867055692508679039;
    
    uint256 constant IC17x = 10883019234468358416777291489310926705365729984320789619813370459112264632846;
    uint256 constant IC17y = 4752242855141079298609384026747406693778365345790700618329428878844197161700;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[17] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
