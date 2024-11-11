//Récupère le 404 (route introuvable) et le transmet au gestionnaire d'erreurs via next()
export function notFoundError(req,res,next){
    const err=new Error("Not Found");//Créer une erreur pour les routes introuvables
    err.status = 404;//definir le code de retour a 404
    next(err);//transmettre l'erreur au middleware suivant
};
/**
 * gestionnaire d'erreurs avec 4 paramétres:
 * le premier paramétre et supposer etre une erreur transmise par le next d'un middleware
 */
export function errorHandler(err,req,res,next){
    //renvoyer a lutilisateur le code et le message de lerreur
    res.status(err.status||500).json({
        message:err.message,
    });
};
