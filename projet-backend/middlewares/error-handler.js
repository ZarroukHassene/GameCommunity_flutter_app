// error-handler.js

// Récupère le 404 (route introuvable) et le transmet au gestionnaire d'erreurs via next()
function notFoundError(req, res, next) {
    const err = new Error("Not Found");
    err.status = 404; // définir le code de retour à 404
    next(err); // transmettre l'erreur au middleware suivant
  }
  
  function errorHandler(err, req, res, next) {
    // renvoyer à l'utilisateur le code et le message de l'erreur
    res.status(err.status || 500).json({
      message: err.message,
    });
  }
  
  module.exports = { notFoundError, errorHandler };
  