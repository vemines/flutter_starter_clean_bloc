const { faker } = require('@faker-js/faker');
const fs = require('fs');

function generateData() {
  let users = [];
  let posts = [];
  let comments = [];
  let userIdCounter = 1;
  let postIdCounter = 1;
  let commentIdCounter = 1;

  for (let i = 0; i < 10; i++) {
    const userDate = faker.date.past();
    const user = {
      id: userIdCounter++,
      fullName: faker.person.fullName(),
      username: faker.internet.username(),
      password: faker.internet.password(),
      email: faker.internet.email(),
      about: faker.lorem.paragraphs(),
      avatar: 'https://i.pravatar.cc/300',
      cover: `https://picsum.photos/800/450?random=${userIdCounter}`,
      createdAt: userDate,
      updatedAt: userDate,
      friendIds: faker.helpers.arrayElements(
        [...Array(10).keys()].map((x) => x + 1),
        faker.number.int({ min: 0, max: 5 }),
      ),
      bookmarkedPosts: faker.helpers.arrayElements(
        [...Array(90).keys()].map((x) => x + 1),
        faker.number.int({ min: 0, max: 3 }),
      ),
    };
    users.push(user);
  }

  for (let i = 0; i < users.length; i++) {
    const user = users[i];
    for (let j = 0; j < 10; j++) {
      const postDate = faker.date.past();
      const post = {
        id: postIdCounter++,
        userId: user.id,
        title: faker.lorem.sentence(),
        body: faker.lorem.paragraphs(),
        imageUrl: `https://picsum.photos/800/450?random=${postIdCounter}`,
        createdAt: postDate,
        updatedAt: postDate,
      };
      posts.push(post);

      for (let k = 0; k < 3; k++) {
        const commentDate = faker.date.past();
        const comment = {
          id: commentIdCounter++,
          postId: post.id,
          userId: faker.helpers.arrayElement(users).id,
          body: faker.lorem.sentence(),
          createdAt: commentDate,
          updatedAt: commentDate,
        };
        comments.push(comment);
      }
    }
  }

  return {
    users: users,
    posts: posts,
    comments: comments,
  };
}

fs.writeFileSync('db.json', JSON.stringify(generateData(), null), 'utf-8');

console.log('db.json file has been generated');
