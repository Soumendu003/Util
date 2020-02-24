#ifndef AVL_TREE_H
#define AVL_TREE_H

template <class T> 
class AVL_Node {
    public:
        AVL_Node(const T& value) : _data(value), _left(NULL), _right(NULL), _parent(NULL) {}
        ~AVL_Node() {}

        const T&  GetValue() const { return _data ; }
        void      SetLeft(AVL_Node* left) { _left = left ; }
        AVL_Node*  GetLeft() const { return _left ; }
        void      GetRight(AVL_Node* right) { _right = right ; }
        AVL_Node*  GetRight() const { return _right ; }
        void      SetParent(AVL_Node* parent) { _parent = parent ; }
        AVL_Node*  GetParent() const { return _parent ; }

        void      Print() const { std::cout << _data << std::endl ; }

    private:
        AVLNode();

        T     _data;
        AVLNode* _left;
        AVLNode* _right;
        AVLNode* _parent;
};



#endif