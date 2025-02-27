// index.js
const { faker } = require('@faker-js/faker');
const jsonServer = require('@wll8/json-server');
const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();
const _ = require('lodash');

server.use(middlewares);
server.use(jsonServer.bodyParser);

const delayMiddleware = (delay) => (req, res, next) => {
  setTimeout(next, delay);
};

const DELAY_MS = 500;
server.use(delayMiddleware(DELAY_MS));

// Custom middleware for request modification
server.use((req, res, next) => {
  if (req.method === 'POST') {
    req.body.createdAt = new Date().toISOString();
    req.body.updatedAt = new Date().toISOString();
  } else if (req.method === 'PATCH' || req.method === 'PUT') {
    req.body.updatedAt = new Date().toISOString();
  }
  next();
});

const secretText = 'some secret text';

server.post('/api/v1/verify', (req, res) => {
  const { secret } = req.body;
  if (secret === secretText) {
    return res.status(200).jsonp({
      message: 'Verified.',
    });
  }
  return res.status(403).jsonp({
    error: 'Unauthentication',
  });
});

// Custom Login Endpoint (POST /api/v1/login)
server.post('/api/v1/login', (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).jsonp({
      error: 'Email and password are required.',
    });
  }

  const users = router.db.get('users').value(); // Access the 'users' array
  const user = users.find((u) => u.username === username && u.password === password);

  if (user) {
    const { password, ...userWithoutPassword } = user; // Remove password
    res.jsonp({ secret: secretText, ...userWithoutPassword });
  } else {
    res.status(401).jsonp({ error: 'Login failure!' });
  }
});

// Custom Register Endpoint (POST /api/v1/register)
server.post('/api/v1/register', (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).jsonp({ error: 'Missing required fields.' });
  }

  const users = router.db.get('users').value();
  if (users.find((u) => u.email === email)) {
    return res.status(409).jsonp({ error: 'Email already registered.' });
  }
  if (users.find((u) => u.username === username)) {
    return res.status(409).jsonp({ error: 'username already registered.' });
  }

  const newUser = {
    id: users.length + 1,
    fullName: username,
    username,
    email,
    password,
    about: faker.lorem.paragraphs(),
    avatar: 'https://i.pravatar.cc/300',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    friendIds: [],
    bookmarkedPosts: [], // Initialize bookmarkedPosts
  };

  router.db.get('users').push(newUser).write(); // Add the new user

  const { password: _, ...userWithoutPassword } = newUser;
  res.status(201).jsonp({ secret: secretText, ...userWithoutPassword }); // 201 Created
});

// Get single post + comments
server.get('/api/v1/posts/:id/details', (req, res) => {
  const postId = parseInt(req.params.id);
  const post = router.db.get('posts').find({ id: postId }).value();

  if (!post) {
    return res.status(404).jsonp({ error: 'Post not found' });
  }

  const comments = router.db.get('comments').filter({ postId: postId }).value();
  const commentsWithUserDetails = comments.map((comment) => {
    const user = router.db.get('users').find({ id: comment.userId }).value();
    const { password, ...userWithoutPassword } = user;
    return {
      ...comment,
      user: userWithoutPassword,
    };
  });

  const { userId, ...postWithoutUserId } = post;
  const user = router.db.get('users').find({ id: userId }).value();
  const { password, ...userWithoutPassword } = user;

  res.jsonp({ ...postWithoutUserId, user: userWithoutPassword, comments: commentsWithUserDetails }); //Destructed post
});

// Update bookmarked posts (NOW ON THE USER)
server.patch('/api/v1/users/:id/bookmark', (req, res) => {
  const userId = parseInt(req.params.id);
  const { postId } = req.body;

  if (!postId) {
    return res.status(400).jsonp({ error: 'postId is required' });
  }

  const user = router.db.get('users').find({ id: userId }).value();
  if (!user) {
    return res.status(404).jsonp({ error: 'User not found' });
  }

  const post = router.db.get('posts').find({ id: postId }).value();
  if (!post) {
    return res.status(404).jsonp({ error: 'Post not found' });
  }

  let bookmarkedPosts = user.bookmarkedPosts || [];
  if (bookmarkedPosts.includes(postId)) {
    bookmarkedPosts = bookmarkedPosts.filter((id) => id !== postId); // Remove if already bookmarked
  } else {
    bookmarkedPosts.push(postId); // Add if not bookmarked
  }

  router.db.get('users').find({ id: userId }).assign({ bookmarkedPosts }).write();
  res.jsonp(router.db.get('users').find({ id: userId }).value());
});

// Update friend list
server.patch('/api/v1/users/:id/friends', (req, res) => {
  const userId = parseInt(req.params.id);
  const { friendIds } = req.body; // Expect an array of friend IDs

  if (!Array.isArray(friendIds)) {
    return res.status(400).jsonp({ error: 'friendIds must be an array' });
  }

  const user = router.db.get('users').find({ id: userId }).value();
  if (!user) {
    return res.status(404).jsonp({ error: 'User not found' });
  }

  // Basic validation: Check if all friend IDs are valid users
  const users = router.db.get('users').value();
  const allUserIds = users.map((u) => u.id);
  if (!friendIds.every((friendId) => allUserIds.includes(friendId))) {
    return res.status(400).jsonp({ error: 'Invalid friendId(s) provided' });
  }

  router.db.get('users').find({ id: userId }).assign({ friendIds }).write();
  res.jsonp(router.db.get('users').find({ id: userId }).value());
});

// Get user + posts + comments + bookmarked posts
server.get('/api/v1/users/:id/details', (req, res) => {
  const userId = parseInt(req.params.id);
  const user = router.db.get('users').find({ id: userId }).value();

  if (!user) {
    return res.status(404).jsonp({ error: 'User not found' });
  }

  const posts = router.db.get('posts').filter({ userId: userId }).value();
  const comments = router.db.get('comments').filter({ userId: userId }).value();
  const { password, ...userWithoutPassword } = user;

  res.jsonp({ ...userWithoutPassword, posts, comments });
});

// Add comment to post (with user details)
server.post('/api/v1/posts/:postId/comments', (req, res) => {
  const postId = parseInt(req.params.postId);
  const { userId, body } = req.body;

  if (!userId || !body) {
    return res.status(400).jsonp({ error: 'userId and body are required' });
  }

  const post = router.db.get('posts').find({ id: postId }).value();
  if (!post) {
    return res.status(404).jsonp({ error: 'Post not found' });
  }
  const user = router.db.get('users').find({ id: userId }).value();
  if (!user) {
    return res.status(404).jsonp({ error: 'User not found' });
  }

  const newComment = {
    id: router.db.get('comments').value().length + 1,
    postId,
    userId,
    body,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  router.db.get('comments').push(newComment).write();
  const { password, ...userWithoutPassword } = user;
  res.status(201).jsonp({ ...newComment, user: userWithoutPassword });
});

// Get comments for a post with user details (reload post comments)
server.get('/api/v1/posts/:postId/comments', (req, res) => {
  const postId = parseInt(req.params.postId);
  const page = parseInt(req.query._page) || 1;
  const limit = parseInt(req.query._limit) || 10;
  const sortField = req.query._sort || 'updatedAt';
  const sortOrder = req.query._order || 'desc';

  let comments = router.db.get('comments').filter({ postId }).value();

  // Sorting
  comments = _.orderBy(comments, [sortField], [sortOrder]);

  // Pagination
  const startIndex = (page - 1) * limit;
  const endIndex = page * limit;
  comments = comments.slice(startIndex, endIndex);

  const commentsWithUserDetails = comments.map((comment) => {
    const user = router.db.get('users').find({ id: comment.userId }).value();
    if (!user) return { ...comment, user: null }; //Handle case no user;
    const { password, ...userWithoutPassword } = user; //remove password
    return {
      ...comment,
      user: userWithoutPassword,
    };
  });

  res.jsonp(commentsWithUserDetails);
});

// Edit/Delete comment (check if author)
server.patch('/api/v1/comments/:id', (req, res) => {
  const commentId = parseInt(req.params.id);
  const { userId, body } = req.body;

  const comment = router.db.get('comments').find({ id: commentId }).value();
  if (!comment) {
    return res.status(404).jsonp({ error: 'Comment not found' });
  }

  if (comment.userId !== userId) {
    return res.status(403).jsonp({ error: 'Unauthorized: You can only edit your own comments' });
  }

  if (body) {
    router.db
      .get('comments')
      .find({ id: commentId })
      .assign({ body, updatedAt: new Date().toISOString() })
      .write();
  }

  res.jsonp(router.db.get('comments').find({ id: commentId }).value());
});

server.delete('/api/v1/comments/:id', (req, res) => {
  const commentId = parseInt(req.params.id);
  const { userId } = req.body; // Send userId in the body for delete too

  const comment = router.db.get('comments').find({ id: commentId }).value();
  if (!comment) {
    return res.status(404).jsonp({ error: 'Comment not found' });
  }

  if (comment.userId !== userId) {
    return res.status(403).jsonp({ error: 'Unauthorized: You can only delete your own comments' });
  }

  router.db.get('comments').remove({ id: commentId }).write();
  res.jsonp({ message: 'Comment deleted' });
});

server.use('/api/v1', router);

server.listen(3000, () => {
  console.log('JSON Server is running on http://localhost:3000');
});
