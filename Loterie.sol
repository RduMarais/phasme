pragma solidity ^0.5.0;
// indique la version du compilateur

contract Loterie { 

	// -------------------- variables -----------------------------------------	
	uint public lastRoundTimestamp;
	uint public nextRoundTimestamp; 
	uint _interval; 
	uint _bloc_cible; // le bloc sur le nonce duquel les participants vont parier
	address _organisation; //l'organisation de la loterie
	address _beneficiaire; //l'ONG bénéficiant de la loterie

	struct Pari { 
		address payable participant; 
		uint nonce_deviné; 
		uint mise; 
	}
	Pari[] public paris;

	event Finished(uint number, uint nextRoundTimestamp);
	// fin des variables

	// -------------------- constructeur --------------------------------------
	// ici encore la syntaxe de la doc est dépréciée, il faut utiliser le constructeur prévu ("constructor(...) { ... }")
	constructor(uint bloc_cible) public { 
		_bloc_cible = bloc_cible; 
		_organisation = msg.sender; //msg est le message qui appelle le smart contract
		//nextRoundTimestamp = now + _interval; //à calculer 
	}


	// --------------------- modifieurs de fonction ---------------------------

	// le underscore est un opérateur qui symbolise le code de la fonction modifiée
	// équivalent : si il y n'y a pas d'ether dans la TX require(false) ==> throw (exception), else do ...
    modifier transactionMustContainEther() {
        if (msg.value == 0) require(false);
        _ ;
    }
	// contrairement à ce qui est indiqué dans la doc, il faut mettre un ";" après l'underscore

	// dans le business model de la Loterie cette méthode n'est pas pertinente
	// parcourt les paris en cours pour calculer la somme maximale que la banque devra payer si tous les joueurs gagnent
	// modifier bankMustBeAbleToPayForPariType(PariType betType) { 
	// 	uint necessaryBalance = 0; 
	// 	for (uint i = 0; i < paris.length; i++) { 
	// 		necessaryBalance += paris[i].mise; 
	// 	}
	// 	necessaryBalance += msg.mise;
	// 	if (necessaryBalance > address(this).balance) require(false); 
	// 	_ ;
	// }
	// contrairement à ce qui est indiqué dans la doc, il faut mettre un ";" après l'underscore


	// -------------------- parier -----------------------------------------
	// plein de modifiers qui vérifient la validité de l'appel
	/*function betSingle(uint number) public payable transactionMustContainEther() {
		if (number > 36) require(false); // arrête l'éxécution si pb
		paris.push(Pari({
			 betType: PariType.Single, participant: msg.sender, number: number, mise: msg.value 
		})); 		// parcourt les paris de type single (sur un chiffre) et les ajoute au tableau paris
	}

	function betEven() public payable transactionMustContainEther() {
		paris.push(Pari({
			betType: PariType.Even, participant: msg.sender, number: 0, mise: msg.value 
		}));
	}*/

	// parier
	// TODO : nonce sur lequel il parie
	function parier() public payable transactionMustContainEther(){
		paris.push(Pari({
			participant: msg.sender, nonce_deviné: 0, mise: msg.value 
		}));
	}

	// --------------------- sorte d'API mais dans la Blockchain -----------------
	// contrairement à ce qui est indiqué dans la doc, le modifier "constant" est déprécié, il faut utiliser "view"
	function getParisCountAndValue() public view returns(uint, uint) {
		uint gain = 0;
		for (uint i = 0; i < paris.length; i++) {
			gain += paris[i].mise;
		}
		return (paris.length, gain); // retourne le nombre de paris et la valeur totale des gains
	}


	// --------------------- faire tourner la roulette --------------------------

	function launch() public {
		//TODO : calculer avec l'index du bloc
		if (now < nextRoundTimestamp) require(false);

		//tirage de nombre aléatoire en utilisant le hash du bloc précédent
		uint nonce = uint(blockhash(block.nonce)); // TODO : on ne considère que les derniers chiffres
		uint gain;
		
		for (uint i = 0; i < paris.length; i++){
			uint[] nonce_diffs;
			nonce_diffs[i] = uint(paris.nonce_deviné - nonce) // toujours positif
			// TODO : déterminer l'écart minimum
		}
		// on parcourt tous les paris --> prix en gaz ??
		uint j = 0;
		while(nonce_diffs[j] > diff_min)
			// TODO : vérifier que c'est bien l'ordre chronologique
			j++;
		}
		paris[j].participant.transfer(gains * 0.3); // rewarde le vainqueur
		_organisation.transfer(gains * 0.1); // reward l'_organisation
		_beneficiaire.transfer(gains * 0.6); // reward le bénéficiaire

	}

}