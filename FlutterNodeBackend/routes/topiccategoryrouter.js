
import  TopicCategoryController  from '../controllers/topiccategorycontroller.js';
import express from 'express';
const router = express.Router();

router.get('/', TopicCategoryController.getAllCategories);
router.post('/', TopicCategoryController.createCategory);
router.put('/:categoryId', TopicCategoryController.updateCategory);
router.delete('/:categoryId', TopicCategoryController.deleteCategory);

export default router;