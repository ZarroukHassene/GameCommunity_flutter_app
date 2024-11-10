import multer,{diskStorage} from "multer";//importer multer
import { join,dirname } from "path";
import { fileURLToPath } from "url";

//les extensions à accepter
const MIME_TYPES={
    "image/jpg":"jpg",
    "image/jpeg":"jpg",
    "image/png":"png",
};

export default multer({
    //Configuration de stockage
    storage:diskStorage({
        //configurer l'emplacement de stockage
        destination : (req,file,callback)=>{
            const _dirname = dirname(fileURLToPath(import.meta.url));//reccuperer le chemin de dossier courant
            callback(null,join(_dirname,"../public/images"));//indiquer l'emplacement de stockage
        },
        //configurer le nom avec la quelle le fichier va etre enregistrer
        filename:(req,file,callback)=>{
            //remplacer les espace par des underscores
            const name = file.originalname.split(" ").join("_");
            //Recuperer lextention a utiliser pour le fichier
            const extension = MIME_TYPES[file.mimetype];
            //ajouter un timestamp Date.now() au nom de fichier
            callback(null,name+Date.now()+"."+extension);
        },
    }),
    //Taille max des image 10Mo
    limits: 10*1024*1024,
}).single("image");//le fichier est envoye dans le body avec nom/cle 'image'