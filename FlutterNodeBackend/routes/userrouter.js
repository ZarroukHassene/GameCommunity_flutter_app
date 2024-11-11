/**
*Creation des Route le fichier routes/game.js
**/ 
import express from 'express';
import { body } from 'express-validator';
const router = express.Router();
import {getAll,getOnce,AddOnce, Sauthentifier ,findByUserName, deleteOnce,toggleUserBan ,toggleUserRole , updateUser} from '../controllers/usercontroller.js';//imporeter les fonction créer dans le controlleur
import multer from '../middlewares/multer-config.js';//importer la configuration de multer
router.use(express.json());//pour analyser (parsing )les requetes application/json
/**
 * Demander l'adresse (URL) de base '/' 
 * a laide de la méthode GET de HTTP
 */

router.route('/')
.get(getAll)
.post(
    multer, //Utiliser multer
    body('username').isLength({min:5}),//le nom doit comporter au moins 5 caractéres
    body('password').isLength({min:4}),//le nom doit comporter au moins 5 caractéres
    body('email').isEmail(),
    // body('xp').isNumeric(),//le date doit etre composée de chiffres
    // body('coins').isNumeric(),//le date doit etre composée de chiffres
    AddOnce)
.put(updateUser);

router.route('/changeRole')
.post(toggleUserRole);
router.route('/banUser')
.post(toggleUserBan);

router.route('/:username')
.get(getOnce)
.delete(deleteOnce);
router.route('/find/:username')
.get(findByUserName);

router.route('/login')
.post(Sauthentifier);




export default router;