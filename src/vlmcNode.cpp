#include "vlmcmethods.h"

vlmcNode::vlmcNode(int lbl){
    label = lbl;
}

vlmcNode::~vlmcNode(){
    if(this->children.size() > 0){
        for(unsigned int i = 0; i<this->children.size(); i++){
            delete this->children[i];
        }
    }
}

void vlmcNode::growChildren(unsigned int m){
    if(this->children.size() == 0){
        vector<vlmcNode*> ch;
        for(unsigned int i=0; i<m; i++){
            vlmcNode* a = new vlmcNode(i);
            a->parent = this;
            a->h = a->parent->h + 1;
            ch.push_back(a);
        }
        this->children = ch;
    }
}

void vlmcNode::growPerfect(unsigned int m, unsigned int H){
    // Only allowed in an empty tree.
    if(this->parent == NULL && this->children.size() == 0){
        int l;
        vector<vlmcNode*> currentLeaves;
        for(unsigned int h=0; h<H; h++){
            currentLeaves = this->getLeaves();
            l = currentLeaves.size();
            for(long unsigned int i=0; i<l; i++){
                currentLeaves[i]->growChildren(m);
            }
        }
    }
}

bool vlmcNode::isLeaf(){
    return(this->children.size() == 0);
}

string vlmcNode::getPath(){
    vector<int> path;
    vlmcNode* node = this;
    path.push_back(node->label);
    while(node->parent != NULL){
        node = node->parent;
        path.push_back(node->label);
    }
    
    std::stringstream ss;
    for(size_t i = 0; i < path.size(); ++i){
        if(path[i] > -1){
            ss << path[i];
        } else {
            ss << 'r';
        }
    }
    std::string s = ss.str();
    s = std::string(s.rbegin(), s.rend());
    return(s);
}

vector<vlmcNode*> vlmcNode::getNodes(){
    vector<vlmcNode*> nodes;
    nodes.push_back(this);
    if(this->children.size() > 0){
        int i = 0;
        while(i < nodes.size()){
            for(long unsigned int j=0; j<nodes[i]->children.size(); j++){
                nodes.push_back(nodes[i]->children[j]);
            }    
            i++;
        }
    }
    return(nodes);
}

vector<vlmcNode*> vlmcNode::getLeaves(){
    vector<vlmcNode*> leaves;
    vector<vlmcNode*> allNodes = this->getNodes();
    int l = allNodes.size();
    for(long unsigned int i=0; i<l; i++){
        if(allNodes[i]->isLeaf()){
            leaves.push_back(allNodes[i]);
        }
    }
    return(leaves);
}

vector<vlmcNode*> vlmcNode::getSiblings(){
    if(this->parent == NULL){
        vector<vlmcNode*> rootVec;
        rootVec.push_back(this);
        return(rootVec);
    } else {
        return(this->parent->children);
    }
}