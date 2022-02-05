//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Blog {
    string public name;
    address public owner;

    using Counters for Counters.Counter;
    Counters.Counter private _postIds;

    struct Post {
      uint id;
      string title;
      string[] items;
    }

    mapping(uint => Post) private idToPost;

    event PostCreated(uint id, string title, string hash);
    event PostUpdated(uint id, string title);
    event PostAdded(uint id, string hash);
    event OwnershipUpdated(address newOwner);

    constructor(string memory _name) {
        console.log("Deploying Blog with name:", _name);
        name = _name;
        owner = msg.sender;
    }

    function getGreeting() public pure returns(string memory) {
        return "Hello world";
    }

    function updateName(string memory _name) public {
        name = _name;
    }

    function transferOwnership(address newOwner) public {
        require(owner == msg.sender, "Not allowed to update owner");
        owner = newOwner;
    }

    function createPost(string memory title, string memory hash) public {
        require(owner == msg.sender, "Not allowed to create a post");
        _postIds.increment();
        uint postId = _postIds.current();
        Post storage post = idToPost[postId];
        post.title = title;
        post.items.push(hash);
        emit PostCreated(postId, title, hash);
    }

    function updatePost(uint postId, string memory title) public {
        require(owner == msg.sender, "Not allowed to update this post");
        Post storage post =  idToPost[postId];
        post.title = title;
        idToPost[postId] = post;
        emit PostUpdated(post.id, title);
    }

    function addPost(uint postId, string memory hash) public {
        require(owner == msg.sender, "Not allowed to add post");
        Post storage post = idToPost[postId];
        post.items.push(hash);
        emit PostAdded(postId, hash);
    }

    function fetchPosts() public view returns (Post[] memory) {
        uint itemCount = _postIds.current();
        uint currentIndex = 0;

        Post[] memory posts = new Post[](itemCount);
        for (uint i = 0; i < itemCount; i++) {
            uint currentId = i + 1;
            Post storage currentItem = idToPost[currentId];
            posts[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return posts;
    }
}
