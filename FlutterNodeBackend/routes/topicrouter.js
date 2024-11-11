import express from 'express';
import  TopicController  from '../controllers/topiccontroller.js';
const router = express.Router();


router.get('/:categoryId', TopicController.getCategoryTopics);
router.post('/:categoryId', TopicController.createTopic);
router.put('/:topicId', TopicController.updateTopicStatus);

export default router;