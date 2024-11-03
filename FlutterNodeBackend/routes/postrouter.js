import express from 'express';
import postController from '../controllers/postcontroller.js';

const router = express.Router();

router.get('/:topicId', postController.getTopicPosts);
router.post('/:topicId', postController.createPost);
router.delete('/:postId', postController.deletePost);


export default router;
