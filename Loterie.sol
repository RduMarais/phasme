pragma solidity ^0.5.0;
// indique la version du compilateur

// TODO : 
// uint256 -> uint8
// nonce ?
// nonce max

contract Loterie { 

	// -------------------- variables -----------------------------------------	
	uint _bloc_cible; // le bloc sur le nonce duquel les participants vont parier
	address payable _organisation; //l organisation de la loterie
	address payable _beneficiaire; //l ONG bénéficiant de la loterie
	uint _mise; //tout le monde mise autant, en wei

	struct Pari { 
		address payable participant; 
		uint nonce_devine; 
	}
	Pari[] public paris;

	event Finished(uint number, uint nextRoundTimestamp);
	// fin des variables

	// -------------------- constructeur --------------------------------------
	constructor(uint bloc_cible, address payable beneficiaire, uint mise) public { 
		_bloc_cible = bloc_cible; 
		_beneficiaire = beneficiaire;
		_organisation = msg.sender; //msg est le message qui appelle le smart contract
		_mise = mise;
	}


	// --------------------- modifieurs de fonction ---------------------------
	// équivalent : si il y n'y a pas d'ether dans la TX require(false) ==> throw (exception), else do ...
    modifier transactionMustContainEther() {
        if (msg.value != _mise) require(false);
        _ ;
    }


	// -------------------- parier -----------------------------------------
	// TODO : nonce sur lequel il parie
	// TODO : mettre des mises personnalisées
	function parier(uint nonce_dev) public payable transactionMustContainEther(){
		paris.push(Pari({
			//TODO : verifier le cast & la mise en forme de msg data
			participant: msg.sender, nonce_devine: nonce_dev /*, mise: msg.value*/ 
		}));
	}

	// --------------------- sorte d'API mais dans la Blockchain -----------------
	// retourne le nombre de paris et la valeur totale des gains
	function getParisCountAndValue() public view returns(uint, uint) {
		return (paris.length, (uint)(paris.length * _mise));
	}


	// --------------------- faire tourner la roulette --------------------------

	function launch() public {
		if (block.number < _bloc_cible) require(false);
		(uint len, uint gain) = getParisCountAndValue();

		uint nonce = uint(blockhash(_bloc_cible)); 
		// TODO : utilser le nonce au lieu du hash
		// TODO : on ne considère que les derniers chiffres
		uint winner = 0;
		uint nonce_diff;
		uint nonce_min = 5000; // arbitrary high value, max of nonce values
		// on parcourt tous les paris --> prix en gaz en O(n) ???
		for (uint i = 0; i < len; i++){
			nonce_diff = uint(paris[i].nonce_devine - nonce); // toujours positif
			if(nonce_diff < nonce_min){
				winner = i;
			}
		}
		// TODO : vérifier que c'est bien l'ordre chronologique
		paris[winner].participant.transfer(gain / 10 * 3); // rewarde le vainqueur
		_organisation.transfer(gain / 10 * 1); // reward l'_organisation
		_beneficiaire.transfer(gain / 10 * 6); // reward le bénéficiaire
		//TODO : frais de transactions
	}

}