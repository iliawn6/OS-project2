
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:



void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d5278793          	addi	a5,a5,-686 # d58 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d2f73d23          	sd	a5,-710(a4) # d48 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d4f72023          	sw	a5,-704(a4) # 2d58 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001517          	auipc	a0,0x1
  32:	d1a53503          	ld	a0,-742(a0) # d48 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	08058593          	addi	a1,a1,128 # 2080 <__global_pointer$+0xb57>
  3c:	95aa                	add	a1,a1,a0
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	f1880813          	addi	a6,a6,-232 # 8f58 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	08068893          	addi	a7,a3,128 # 2080 <__global_pointer$+0xb57>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	cf258593          	addi	a1,a1,-782 # d58 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	ba050513          	addi	a0,a0,-1120 # c10 <malloc+0xe8>
  78:	00001097          	auipc	ra,0x1
  7c:	9f2080e7          	jalr	-1550(ra) # a6a <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	670080e7          	jalr	1648(ra) # 6f2 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b50263          	beq	a0,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6789                	lui	a5,0x2
  90:	00f58733          	add	a4,a1,a5
  94:	4685                	li	a3,1
  96:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  98:	00001717          	auipc	a4,0x1
  9c:	cab73823          	sd	a1,-848(a4) # d48 <current_thread>
    /* YOUR CODE HERE ------done------
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch(&t->context, &current_thread->context);
  a0:	07a1                	addi	a5,a5,8
  a2:	95be                	add	a1,a1,a5
  a4:	953e                	add	a0,a0,a5
  a6:	00000097          	auipc	ra,0x0
  aa:	35a080e7          	jalr	858(ra) # 400 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	c9c78793          	addi	a5,a5,-868 # d58 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	08068593          	addi	a1,a3,128 # 2080 <__global_pointer$+0xb57>
  ca:	00009617          	auipc	a2,0x9
  ce:	e8e60613          	addi	a2,a2,-370 # 8f58 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	97ba                	add	a5,a5,a4
  e4:	4709                	li	a4,2
  e6:	c398                	sw	a4,0(a5)
  //check
  t->context.ra = (uint64)func;
  e8:	e788                	sd	a0,8(a5)
  t->context.sp = (uint64)t->stack + STACK_SIZE;
  ea:	eb9c                	sd	a5,16(a5)
  // YOUR CODE HERE -----done------
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <thread_yield>:

void 
thread_yield(void)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  fa:	00001797          	auipc	a5,0x1
  fe:	c4e7b783          	ld	a5,-946(a5) # d48 <current_thread>
 102:	6709                	lui	a4,0x2
 104:	97ba                	add	a5,a5,a4
 106:	4709                	li	a4,2
 108:	c398                	sw	a4,0(a5)
  thread_schedule();
 10a:	00000097          	auipc	ra,0x0
 10e:	f1c080e7          	jalr	-228(ra) # 26 <thread_schedule>
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	b0e50513          	addi	a0,a0,-1266 # c38 <malloc+0x110>
 132:	00001097          	auipc	ra,0x1
 136:	938080e7          	jalr	-1736(ra) # a6a <printf>
  a_started = 1;
 13a:	4785                	li	a5,1
 13c:	00001717          	auipc	a4,0x1
 140:	c0f72423          	sw	a5,-1016(a4) # d44 <a_started>
  while(b_started == 0 || c_started == 0)
 144:	00001497          	auipc	s1,0x1
 148:	bfc48493          	addi	s1,s1,-1028 # d40 <b_started>
 14c:	00001917          	auipc	s2,0x1
 150:	bf090913          	addi	s2,s2,-1040 # d3c <c_started>
 154:	a029                	j	15e <thread_a+0x44>
    thread_yield();
 156:	00000097          	auipc	ra,0x0
 15a:	f9c080e7          	jalr	-100(ra) # f2 <thread_yield>
  while(b_started == 0 || c_started == 0)
 15e:	409c                	lw	a5,0(s1)
 160:	2781                	sext.w	a5,a5
 162:	dbf5                	beqz	a5,156 <thread_a+0x3c>
 164:	00092783          	lw	a5,0(s2)
 168:	2781                	sext.w	a5,a5
 16a:	d7f5                	beqz	a5,156 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 16c:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 16e:	00001a17          	auipc	s4,0x1
 172:	ae2a0a13          	addi	s4,s4,-1310 # c50 <malloc+0x128>
    a_n += 1;
 176:	00001917          	auipc	s2,0x1
 17a:	bc290913          	addi	s2,s2,-1086 # d38 <a_n>
  for (i = 0; i < 100; i++) {
 17e:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 182:	85a6                	mv	a1,s1
 184:	8552                	mv	a0,s4
 186:	00001097          	auipc	ra,0x1
 18a:	8e4080e7          	jalr	-1820(ra) # a6a <printf>
    a_n += 1;
 18e:	00092783          	lw	a5,0(s2)
 192:	2785                	addiw	a5,a5,1
 194:	00f92023          	sw	a5,0(s2)
    thread_yield();
 198:	00000097          	auipc	ra,0x0
 19c:	f5a080e7          	jalr	-166(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a0:	2485                	addiw	s1,s1,1
 1a2:	ff3490e3          	bne	s1,s3,182 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1a6:	00001597          	auipc	a1,0x1
 1aa:	b925a583          	lw	a1,-1134(a1) # d38 <a_n>
 1ae:	00001517          	auipc	a0,0x1
 1b2:	ab250513          	addi	a0,a0,-1358 # c60 <malloc+0x138>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	8b4080e7          	jalr	-1868(ra) # a6a <printf>

  current_thread->state = FREE;
 1be:	00001797          	auipc	a5,0x1
 1c2:	b8a7b783          	ld	a5,-1142(a5) # d48 <current_thread>
 1c6:	6709                	lui	a4,0x2
 1c8:	97ba                	add	a5,a5,a4
 1ca:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e58080e7          	jalr	-424(ra) # 26 <thread_schedule>
}
 1d6:	70a2                	ld	ra,40(sp)
 1d8:	7402                	ld	s0,32(sp)
 1da:	64e2                	ld	s1,24(sp)
 1dc:	6942                	ld	s2,16(sp)
 1de:	69a2                	ld	s3,8(sp)
 1e0:	6a02                	ld	s4,0(sp)
 1e2:	6145                	addi	sp,sp,48
 1e4:	8082                	ret

00000000000001e6 <thread_b>:

void 
thread_b(void)
{
 1e6:	7179                	addi	sp,sp,-48
 1e8:	f406                	sd	ra,40(sp)
 1ea:	f022                	sd	s0,32(sp)
 1ec:	ec26                	sd	s1,24(sp)
 1ee:	e84a                	sd	s2,16(sp)
 1f0:	e44e                	sd	s3,8(sp)
 1f2:	e052                	sd	s4,0(sp)
 1f4:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	a8a50513          	addi	a0,a0,-1398 # c80 <malloc+0x158>
 1fe:	00001097          	auipc	ra,0x1
 202:	86c080e7          	jalr	-1940(ra) # a6a <printf>
  b_started = 1;
 206:	4785                	li	a5,1
 208:	00001717          	auipc	a4,0x1
 20c:	b2f72c23          	sw	a5,-1224(a4) # d40 <b_started>
  while(a_started == 0 || c_started == 0)
 210:	00001497          	auipc	s1,0x1
 214:	b3448493          	addi	s1,s1,-1228 # d44 <a_started>
 218:	00001917          	auipc	s2,0x1
 21c:	b2490913          	addi	s2,s2,-1244 # d3c <c_started>
 220:	a029                	j	22a <thread_b+0x44>
    thread_yield();
 222:	00000097          	auipc	ra,0x0
 226:	ed0080e7          	jalr	-304(ra) # f2 <thread_yield>
  while(a_started == 0 || c_started == 0)
 22a:	409c                	lw	a5,0(s1)
 22c:	2781                	sext.w	a5,a5
 22e:	dbf5                	beqz	a5,222 <thread_b+0x3c>
 230:	00092783          	lw	a5,0(s2)
 234:	2781                	sext.w	a5,a5
 236:	d7f5                	beqz	a5,222 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 238:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 23a:	00001a17          	auipc	s4,0x1
 23e:	a5ea0a13          	addi	s4,s4,-1442 # c98 <malloc+0x170>
    b_n += 1;
 242:	00001917          	auipc	s2,0x1
 246:	af290913          	addi	s2,s2,-1294 # d34 <b_n>
  for (i = 0; i < 100; i++) {
 24a:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 24e:	85a6                	mv	a1,s1
 250:	8552                	mv	a0,s4
 252:	00001097          	auipc	ra,0x1
 256:	818080e7          	jalr	-2024(ra) # a6a <printf>
    b_n += 1;
 25a:	00092783          	lw	a5,0(s2)
 25e:	2785                	addiw	a5,a5,1
 260:	00f92023          	sw	a5,0(s2)
    thread_yield();
 264:	00000097          	auipc	ra,0x0
 268:	e8e080e7          	jalr	-370(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 26c:	2485                	addiw	s1,s1,1
 26e:	ff3490e3          	bne	s1,s3,24e <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 272:	00001597          	auipc	a1,0x1
 276:	ac25a583          	lw	a1,-1342(a1) # d34 <b_n>
 27a:	00001517          	auipc	a0,0x1
 27e:	a2e50513          	addi	a0,a0,-1490 # ca8 <malloc+0x180>
 282:	00000097          	auipc	ra,0x0
 286:	7e8080e7          	jalr	2024(ra) # a6a <printf>

  current_thread->state = FREE;
 28a:	00001797          	auipc	a5,0x1
 28e:	abe7b783          	ld	a5,-1346(a5) # d48 <current_thread>
 292:	6709                	lui	a4,0x2
 294:	97ba                	add	a5,a5,a4
 296:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 29a:	00000097          	auipc	ra,0x0
 29e:	d8c080e7          	jalr	-628(ra) # 26 <thread_schedule>
}
 2a2:	70a2                	ld	ra,40(sp)
 2a4:	7402                	ld	s0,32(sp)
 2a6:	64e2                	ld	s1,24(sp)
 2a8:	6942                	ld	s2,16(sp)
 2aa:	69a2                	ld	s3,8(sp)
 2ac:	6a02                	ld	s4,0(sp)
 2ae:	6145                	addi	sp,sp,48
 2b0:	8082                	ret

00000000000002b2 <thread_c>:

void 
thread_c(void)
{
 2b2:	7179                	addi	sp,sp,-48
 2b4:	f406                	sd	ra,40(sp)
 2b6:	f022                	sd	s0,32(sp)
 2b8:	ec26                	sd	s1,24(sp)
 2ba:	e84a                	sd	s2,16(sp)
 2bc:	e44e                	sd	s3,8(sp)
 2be:	e052                	sd	s4,0(sp)
 2c0:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	a0650513          	addi	a0,a0,-1530 # cc8 <malloc+0x1a0>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	7a0080e7          	jalr	1952(ra) # a6a <printf>
  c_started = 1;
 2d2:	4785                	li	a5,1
 2d4:	00001717          	auipc	a4,0x1
 2d8:	a6f72423          	sw	a5,-1432(a4) # d3c <c_started>
  while(a_started == 0 || b_started == 0)
 2dc:	00001497          	auipc	s1,0x1
 2e0:	a6848493          	addi	s1,s1,-1432 # d44 <a_started>
 2e4:	00001917          	auipc	s2,0x1
 2e8:	a5c90913          	addi	s2,s2,-1444 # d40 <b_started>
 2ec:	a029                	j	2f6 <thread_c+0x44>
    thread_yield();
 2ee:	00000097          	auipc	ra,0x0
 2f2:	e04080e7          	jalr	-508(ra) # f2 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2f6:	409c                	lw	a5,0(s1)
 2f8:	2781                	sext.w	a5,a5
 2fa:	dbf5                	beqz	a5,2ee <thread_c+0x3c>
 2fc:	00092783          	lw	a5,0(s2)
 300:	2781                	sext.w	a5,a5
 302:	d7f5                	beqz	a5,2ee <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 304:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 306:	00001a17          	auipc	s4,0x1
 30a:	9daa0a13          	addi	s4,s4,-1574 # ce0 <malloc+0x1b8>
    c_n += 1;
 30e:	00001917          	auipc	s2,0x1
 312:	a2290913          	addi	s2,s2,-1502 # d30 <c_n>
  for (i = 0; i < 100; i++) {
 316:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31a:	85a6                	mv	a1,s1
 31c:	8552                	mv	a0,s4
 31e:	00000097          	auipc	ra,0x0
 322:	74c080e7          	jalr	1868(ra) # a6a <printf>
    c_n += 1;
 326:	00092783          	lw	a5,0(s2)
 32a:	2785                	addiw	a5,a5,1
 32c:	00f92023          	sw	a5,0(s2)
    thread_yield();
 330:	00000097          	auipc	ra,0x0
 334:	dc2080e7          	jalr	-574(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 338:	2485                	addiw	s1,s1,1
 33a:	ff3490e3          	bne	s1,s3,31a <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 33e:	00001597          	auipc	a1,0x1
 342:	9f25a583          	lw	a1,-1550(a1) # d30 <c_n>
 346:	00001517          	auipc	a0,0x1
 34a:	9aa50513          	addi	a0,a0,-1622 # cf0 <malloc+0x1c8>
 34e:	00000097          	auipc	ra,0x0
 352:	71c080e7          	jalr	1820(ra) # a6a <printf>

  current_thread->state = FREE;
 356:	00001797          	auipc	a5,0x1
 35a:	9f27b783          	ld	a5,-1550(a5) # d48 <current_thread>
 35e:	6709                	lui	a4,0x2
 360:	97ba                	add	a5,a5,a4
 362:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 366:	00000097          	auipc	ra,0x0
 36a:	cc0080e7          	jalr	-832(ra) # 26 <thread_schedule>
}
 36e:	70a2                	ld	ra,40(sp)
 370:	7402                	ld	s0,32(sp)
 372:	64e2                	ld	s1,24(sp)
 374:	6942                	ld	s2,16(sp)
 376:	69a2                	ld	s3,8(sp)
 378:	6a02                	ld	s4,0(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <main>:

int 
main(int argc, char *argv[]) 
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 386:	00001797          	auipc	a5,0x1
 38a:	9a07ab23          	sw	zero,-1610(a5) # d3c <c_started>
 38e:	00001797          	auipc	a5,0x1
 392:	9a07a923          	sw	zero,-1614(a5) # d40 <b_started>
 396:	00001797          	auipc	a5,0x1
 39a:	9a07a723          	sw	zero,-1618(a5) # d44 <a_started>
  a_n = b_n = c_n = 0;
 39e:	00001797          	auipc	a5,0x1
 3a2:	9807a923          	sw	zero,-1646(a5) # d30 <c_n>
 3a6:	00001797          	auipc	a5,0x1
 3aa:	9807a723          	sw	zero,-1650(a5) # d34 <b_n>
 3ae:	00001797          	auipc	a5,0x1
 3b2:	9807a523          	sw	zero,-1654(a5) # d38 <a_n>
  thread_init();
 3b6:	00000097          	auipc	ra,0x0
 3ba:	c4a080e7          	jalr	-950(ra) # 0 <thread_init>
  thread_create(thread_a);
 3be:	00000517          	auipc	a0,0x0
 3c2:	d5c50513          	addi	a0,a0,-676 # 11a <thread_a>
 3c6:	00000097          	auipc	ra,0x0
 3ca:	cf0080e7          	jalr	-784(ra) # b6 <thread_create>
  thread_create(thread_b);
 3ce:	00000517          	auipc	a0,0x0
 3d2:	e1850513          	addi	a0,a0,-488 # 1e6 <thread_b>
 3d6:	00000097          	auipc	ra,0x0
 3da:	ce0080e7          	jalr	-800(ra) # b6 <thread_create>
  thread_create(thread_c);
 3de:	00000517          	auipc	a0,0x0
 3e2:	ed450513          	addi	a0,a0,-300 # 2b2 <thread_c>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	cd0080e7          	jalr	-816(ra) # b6 <thread_create>
  thread_schedule();
 3ee:	00000097          	auipc	ra,0x0
 3f2:	c38080e7          	jalr	-968(ra) # 26 <thread_schedule>
  exit(0);
 3f6:	4501                	li	a0,0
 3f8:	00000097          	auipc	ra,0x0
 3fc:	2fa080e7          	jalr	762(ra) # 6f2 <exit>

0000000000000400 <thread_switch>:
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
	        sd ra, 0(a0)
 400:	00153023          	sd	ra,0(a0)
            sd sp, 8(a0)
 404:	00253423          	sd	sp,8(a0)
            sd s0, 16(a0)
 408:	e900                	sd	s0,16(a0)
            sd s1, 24(a0)
 40a:	ed04                	sd	s1,24(a0)
            sd s2, 32(a0)
 40c:	03253023          	sd	s2,32(a0)
            sd s3, 40(a0)
 410:	03353423          	sd	s3,40(a0)
            sd s4, 48(a0)
 414:	03453823          	sd	s4,48(a0)
            sd s5, 56(a0)
 418:	03553c23          	sd	s5,56(a0)
            sd s6, 64(a0)
 41c:	05653023          	sd	s6,64(a0)
            sd s7, 72(a0)
 420:	05753423          	sd	s7,72(a0)
            sd s8, 80(a0)
 424:	05853823          	sd	s8,80(a0)
            sd s9, 88(a0)
 428:	05953c23          	sd	s9,88(a0)
            sd s10, 96(a0)
 42c:	07a53023          	sd	s10,96(a0)
            sd s11, 104(a0)
 430:	07b53423          	sd	s11,104(a0)

            ld ra, 0(a1)
 434:	0005b083          	ld	ra,0(a1)
            ld sp, 8(a1)
 438:	0085b103          	ld	sp,8(a1)
            ld s0, 16(a1)
 43c:	6980                	ld	s0,16(a1)
            ld s1, 24(a1)
 43e:	6d84                	ld	s1,24(a1)
            ld s2, 32(a1)
 440:	0205b903          	ld	s2,32(a1)
            ld s3, 40(a1)
 444:	0285b983          	ld	s3,40(a1)
            ld s4, 48(a1)
 448:	0305ba03          	ld	s4,48(a1)
            ld s5, 56(a1)
 44c:	0385ba83          	ld	s5,56(a1)
            ld s6, 64(a1)
 450:	0405bb03          	ld	s6,64(a1)
            ld s7, 72(a1)
 454:	0485bb83          	ld	s7,72(a1)
            ld s8, 80(a1)
 458:	0505bc03          	ld	s8,80(a1)
            ld s9, 88(a1)
 45c:	0585bc83          	ld	s9,88(a1)
            ld s10, 96(a1)
 460:	0605bd03          	ld	s10,96(a1)
            ld s11, 104(a1)
 464:	0685bd83          	ld	s11,104(a1)

	ret    /* return to ra */
 468:	8082                	ret

000000000000046a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  extern int main();
  main();
 472:	00000097          	auipc	ra,0x0
 476:	f0c080e7          	jalr	-244(ra) # 37e <main>
  exit(0);
 47a:	4501                	li	a0,0
 47c:	00000097          	auipc	ra,0x0
 480:	276080e7          	jalr	630(ra) # 6f2 <exit>

0000000000000484 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 484:	1141                	addi	sp,sp,-16
 486:	e422                	sd	s0,8(sp)
 488:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 48a:	87aa                	mv	a5,a0
 48c:	0585                	addi	a1,a1,1
 48e:	0785                	addi	a5,a5,1
 490:	fff5c703          	lbu	a4,-1(a1)
 494:	fee78fa3          	sb	a4,-1(a5)
 498:	fb75                	bnez	a4,48c <strcpy+0x8>
    ;
  return os;
}
 49a:	6422                	ld	s0,8(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret

00000000000004a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a0:	1141                	addi	sp,sp,-16
 4a2:	e422                	sd	s0,8(sp)
 4a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4a6:	00054783          	lbu	a5,0(a0)
 4aa:	cb91                	beqz	a5,4be <strcmp+0x1e>
 4ac:	0005c703          	lbu	a4,0(a1)
 4b0:	00f71763          	bne	a4,a5,4be <strcmp+0x1e>
    p++, q++;
 4b4:	0505                	addi	a0,a0,1
 4b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	fbe5                	bnez	a5,4ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4be:	0005c503          	lbu	a0,0(a1)
}
 4c2:	40a7853b          	subw	a0,a5,a0
 4c6:	6422                	ld	s0,8(sp)
 4c8:	0141                	addi	sp,sp,16
 4ca:	8082                	ret

00000000000004cc <strlen>:

uint
strlen(const char *s)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e422                	sd	s0,8(sp)
 4d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4d2:	00054783          	lbu	a5,0(a0)
 4d6:	cf91                	beqz	a5,4f2 <strlen+0x26>
 4d8:	0505                	addi	a0,a0,1
 4da:	87aa                	mv	a5,a0
 4dc:	4685                	li	a3,1
 4de:	9e89                	subw	a3,a3,a0
 4e0:	00f6853b          	addw	a0,a3,a5
 4e4:	0785                	addi	a5,a5,1
 4e6:	fff7c703          	lbu	a4,-1(a5)
 4ea:	fb7d                	bnez	a4,4e0 <strlen+0x14>
    ;
  return n;
}
 4ec:	6422                	ld	s0,8(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret
  for(n = 0; s[n]; n++)
 4f2:	4501                	li	a0,0
 4f4:	bfe5                	j	4ec <strlen+0x20>

00000000000004f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4f6:	1141                	addi	sp,sp,-16
 4f8:	e422                	sd	s0,8(sp)
 4fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4fc:	ca19                	beqz	a2,512 <memset+0x1c>
 4fe:	87aa                	mv	a5,a0
 500:	1602                	slli	a2,a2,0x20
 502:	9201                	srli	a2,a2,0x20
 504:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 508:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 50c:	0785                	addi	a5,a5,1
 50e:	fee79de3          	bne	a5,a4,508 <memset+0x12>
  }
  return dst;
}
 512:	6422                	ld	s0,8(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret

0000000000000518 <strchr>:

char*
strchr(const char *s, char c)
{
 518:	1141                	addi	sp,sp,-16
 51a:	e422                	sd	s0,8(sp)
 51c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 51e:	00054783          	lbu	a5,0(a0)
 522:	cb99                	beqz	a5,538 <strchr+0x20>
    if(*s == c)
 524:	00f58763          	beq	a1,a5,532 <strchr+0x1a>
  for(; *s; s++)
 528:	0505                	addi	a0,a0,1
 52a:	00054783          	lbu	a5,0(a0)
 52e:	fbfd                	bnez	a5,524 <strchr+0xc>
      return (char*)s;
  return 0;
 530:	4501                	li	a0,0
}
 532:	6422                	ld	s0,8(sp)
 534:	0141                	addi	sp,sp,16
 536:	8082                	ret
  return 0;
 538:	4501                	li	a0,0
 53a:	bfe5                	j	532 <strchr+0x1a>

000000000000053c <gets>:

char*
gets(char *buf, int max)
{
 53c:	711d                	addi	sp,sp,-96
 53e:	ec86                	sd	ra,88(sp)
 540:	e8a2                	sd	s0,80(sp)
 542:	e4a6                	sd	s1,72(sp)
 544:	e0ca                	sd	s2,64(sp)
 546:	fc4e                	sd	s3,56(sp)
 548:	f852                	sd	s4,48(sp)
 54a:	f456                	sd	s5,40(sp)
 54c:	f05a                	sd	s6,32(sp)
 54e:	ec5e                	sd	s7,24(sp)
 550:	1080                	addi	s0,sp,96
 552:	8baa                	mv	s7,a0
 554:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 556:	892a                	mv	s2,a0
 558:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 55a:	4aa9                	li	s5,10
 55c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 55e:	89a6                	mv	s3,s1
 560:	2485                	addiw	s1,s1,1
 562:	0344d863          	bge	s1,s4,592 <gets+0x56>
    cc = read(0, &c, 1);
 566:	4605                	li	a2,1
 568:	faf40593          	addi	a1,s0,-81
 56c:	4501                	li	a0,0
 56e:	00000097          	auipc	ra,0x0
 572:	19c080e7          	jalr	412(ra) # 70a <read>
    if(cc < 1)
 576:	00a05e63          	blez	a0,592 <gets+0x56>
    buf[i++] = c;
 57a:	faf44783          	lbu	a5,-81(s0)
 57e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 582:	01578763          	beq	a5,s5,590 <gets+0x54>
 586:	0905                	addi	s2,s2,1
 588:	fd679be3          	bne	a5,s6,55e <gets+0x22>
  for(i=0; i+1 < max; ){
 58c:	89a6                	mv	s3,s1
 58e:	a011                	j	592 <gets+0x56>
 590:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 592:	99de                	add	s3,s3,s7
 594:	00098023          	sb	zero,0(s3)
  return buf;
}
 598:	855e                	mv	a0,s7
 59a:	60e6                	ld	ra,88(sp)
 59c:	6446                	ld	s0,80(sp)
 59e:	64a6                	ld	s1,72(sp)
 5a0:	6906                	ld	s2,64(sp)
 5a2:	79e2                	ld	s3,56(sp)
 5a4:	7a42                	ld	s4,48(sp)
 5a6:	7aa2                	ld	s5,40(sp)
 5a8:	7b02                	ld	s6,32(sp)
 5aa:	6be2                	ld	s7,24(sp)
 5ac:	6125                	addi	sp,sp,96
 5ae:	8082                	ret

00000000000005b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 5b0:	1101                	addi	sp,sp,-32
 5b2:	ec06                	sd	ra,24(sp)
 5b4:	e822                	sd	s0,16(sp)
 5b6:	e426                	sd	s1,8(sp)
 5b8:	e04a                	sd	s2,0(sp)
 5ba:	1000                	addi	s0,sp,32
 5bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5be:	4581                	li	a1,0
 5c0:	00000097          	auipc	ra,0x0
 5c4:	172080e7          	jalr	370(ra) # 732 <open>
  if(fd < 0)
 5c8:	02054563          	bltz	a0,5f2 <stat+0x42>
 5cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5ce:	85ca                	mv	a1,s2
 5d0:	00000097          	auipc	ra,0x0
 5d4:	17a080e7          	jalr	378(ra) # 74a <fstat>
 5d8:	892a                	mv	s2,a0
  close(fd);
 5da:	8526                	mv	a0,s1
 5dc:	00000097          	auipc	ra,0x0
 5e0:	13e080e7          	jalr	318(ra) # 71a <close>
  return r;
}
 5e4:	854a                	mv	a0,s2
 5e6:	60e2                	ld	ra,24(sp)
 5e8:	6442                	ld	s0,16(sp)
 5ea:	64a2                	ld	s1,8(sp)
 5ec:	6902                	ld	s2,0(sp)
 5ee:	6105                	addi	sp,sp,32
 5f0:	8082                	ret
    return -1;
 5f2:	597d                	li	s2,-1
 5f4:	bfc5                	j	5e4 <stat+0x34>

00000000000005f6 <atoi>:

int
atoi(const char *s)
{
 5f6:	1141                	addi	sp,sp,-16
 5f8:	e422                	sd	s0,8(sp)
 5fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5fc:	00054603          	lbu	a2,0(a0)
 600:	fd06079b          	addiw	a5,a2,-48
 604:	0ff7f793          	andi	a5,a5,255
 608:	4725                	li	a4,9
 60a:	02f76963          	bltu	a4,a5,63c <atoi+0x46>
 60e:	86aa                	mv	a3,a0
  n = 0;
 610:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 612:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 614:	0685                	addi	a3,a3,1
 616:	0025179b          	slliw	a5,a0,0x2
 61a:	9fa9                	addw	a5,a5,a0
 61c:	0017979b          	slliw	a5,a5,0x1
 620:	9fb1                	addw	a5,a5,a2
 622:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 626:	0006c603          	lbu	a2,0(a3)
 62a:	fd06071b          	addiw	a4,a2,-48
 62e:	0ff77713          	andi	a4,a4,255
 632:	fee5f1e3          	bgeu	a1,a4,614 <atoi+0x1e>
  return n;
}
 636:	6422                	ld	s0,8(sp)
 638:	0141                	addi	sp,sp,16
 63a:	8082                	ret
  n = 0;
 63c:	4501                	li	a0,0
 63e:	bfe5                	j	636 <atoi+0x40>

0000000000000640 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 640:	1141                	addi	sp,sp,-16
 642:	e422                	sd	s0,8(sp)
 644:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 646:	02b57463          	bgeu	a0,a1,66e <memmove+0x2e>
    while(n-- > 0)
 64a:	00c05f63          	blez	a2,668 <memmove+0x28>
 64e:	1602                	slli	a2,a2,0x20
 650:	9201                	srli	a2,a2,0x20
 652:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 656:	872a                	mv	a4,a0
      *dst++ = *src++;
 658:	0585                	addi	a1,a1,1
 65a:	0705                	addi	a4,a4,1
 65c:	fff5c683          	lbu	a3,-1(a1)
 660:	fed70fa3          	sb	a3,-1(a4) # 1fff <__global_pointer$+0xad6>
    while(n-- > 0)
 664:	fee79ae3          	bne	a5,a4,658 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 668:	6422                	ld	s0,8(sp)
 66a:	0141                	addi	sp,sp,16
 66c:	8082                	ret
    dst += n;
 66e:	00c50733          	add	a4,a0,a2
    src += n;
 672:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 674:	fec05ae3          	blez	a2,668 <memmove+0x28>
 678:	fff6079b          	addiw	a5,a2,-1
 67c:	1782                	slli	a5,a5,0x20
 67e:	9381                	srli	a5,a5,0x20
 680:	fff7c793          	not	a5,a5
 684:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 686:	15fd                	addi	a1,a1,-1
 688:	177d                	addi	a4,a4,-1
 68a:	0005c683          	lbu	a3,0(a1)
 68e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 692:	fee79ae3          	bne	a5,a4,686 <memmove+0x46>
 696:	bfc9                	j	668 <memmove+0x28>

0000000000000698 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 698:	1141                	addi	sp,sp,-16
 69a:	e422                	sd	s0,8(sp)
 69c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 69e:	ca05                	beqz	a2,6ce <memcmp+0x36>
 6a0:	fff6069b          	addiw	a3,a2,-1
 6a4:	1682                	slli	a3,a3,0x20
 6a6:	9281                	srli	a3,a3,0x20
 6a8:	0685                	addi	a3,a3,1
 6aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6ac:	00054783          	lbu	a5,0(a0)
 6b0:	0005c703          	lbu	a4,0(a1)
 6b4:	00e79863          	bne	a5,a4,6c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6b8:	0505                	addi	a0,a0,1
    p2++;
 6ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6bc:	fed518e3          	bne	a0,a3,6ac <memcmp+0x14>
  }
  return 0;
 6c0:	4501                	li	a0,0
 6c2:	a019                	j	6c8 <memcmp+0x30>
      return *p1 - *p2;
 6c4:	40e7853b          	subw	a0,a5,a4
}
 6c8:	6422                	ld	s0,8(sp)
 6ca:	0141                	addi	sp,sp,16
 6cc:	8082                	ret
  return 0;
 6ce:	4501                	li	a0,0
 6d0:	bfe5                	j	6c8 <memcmp+0x30>

00000000000006d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6d2:	1141                	addi	sp,sp,-16
 6d4:	e406                	sd	ra,8(sp)
 6d6:	e022                	sd	s0,0(sp)
 6d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6da:	00000097          	auipc	ra,0x0
 6de:	f66080e7          	jalr	-154(ra) # 640 <memmove>
}
 6e2:	60a2                	ld	ra,8(sp)
 6e4:	6402                	ld	s0,0(sp)
 6e6:	0141                	addi	sp,sp,16
 6e8:	8082                	ret

00000000000006ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ea:	4885                	li	a7,1
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6f2:	4889                	li	a7,2
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 6fa:	488d                	li	a7,3
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 702:	4891                	li	a7,4
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <read>:
.global read
read:
 li a7, SYS_read
 70a:	4895                	li	a7,5
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <write>:
.global write
write:
 li a7, SYS_write
 712:	48c1                	li	a7,16
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <close>:
.global close
close:
 li a7, SYS_close
 71a:	48d5                	li	a7,21
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <kill>:
.global kill
kill:
 li a7, SYS_kill
 722:	4899                	li	a7,6
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <exec>:
.global exec
exec:
 li a7, SYS_exec
 72a:	489d                	li	a7,7
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <open>:
.global open
open:
 li a7, SYS_open
 732:	48bd                	li	a7,15
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 73a:	48c5                	li	a7,17
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 742:	48c9                	li	a7,18
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 74a:	48a1                	li	a7,8
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <link>:
.global link
link:
 li a7, SYS_link
 752:	48cd                	li	a7,19
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 75a:	48d1                	li	a7,20
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 762:	48a5                	li	a7,9
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <dup>:
.global dup
dup:
 li a7, SYS_dup
 76a:	48a9                	li	a7,10
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 772:	48ad                	li	a7,11
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 77a:	48b1                	li	a7,12
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 782:	48b5                	li	a7,13
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 78a:	48b9                	li	a7,14
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 792:	1101                	addi	sp,sp,-32
 794:	ec06                	sd	ra,24(sp)
 796:	e822                	sd	s0,16(sp)
 798:	1000                	addi	s0,sp,32
 79a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 79e:	4605                	li	a2,1
 7a0:	fef40593          	addi	a1,s0,-17
 7a4:	00000097          	auipc	ra,0x0
 7a8:	f6e080e7          	jalr	-146(ra) # 712 <write>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6105                	addi	sp,sp,32
 7b2:	8082                	ret

00000000000007b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b4:	7139                	addi	sp,sp,-64
 7b6:	fc06                	sd	ra,56(sp)
 7b8:	f822                	sd	s0,48(sp)
 7ba:	f426                	sd	s1,40(sp)
 7bc:	f04a                	sd	s2,32(sp)
 7be:	ec4e                	sd	s3,24(sp)
 7c0:	0080                	addi	s0,sp,64
 7c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7c4:	c299                	beqz	a3,7ca <printint+0x16>
 7c6:	0805c863          	bltz	a1,856 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ca:	2581                	sext.w	a1,a1
  neg = 0;
 7cc:	4881                	li	a7,0
 7ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7d4:	2601                	sext.w	a2,a2
 7d6:	00000517          	auipc	a0,0x0
 7da:	54250513          	addi	a0,a0,1346 # d18 <digits>
 7de:	883a                	mv	a6,a4
 7e0:	2705                	addiw	a4,a4,1
 7e2:	02c5f7bb          	remuw	a5,a1,a2
 7e6:	1782                	slli	a5,a5,0x20
 7e8:	9381                	srli	a5,a5,0x20
 7ea:	97aa                	add	a5,a5,a0
 7ec:	0007c783          	lbu	a5,0(a5)
 7f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7f4:	0005879b          	sext.w	a5,a1
 7f8:	02c5d5bb          	divuw	a1,a1,a2
 7fc:	0685                	addi	a3,a3,1
 7fe:	fec7f0e3          	bgeu	a5,a2,7de <printint+0x2a>
  if(neg)
 802:	00088b63          	beqz	a7,818 <printint+0x64>
    buf[i++] = '-';
 806:	fd040793          	addi	a5,s0,-48
 80a:	973e                	add	a4,a4,a5
 80c:	02d00793          	li	a5,45
 810:	fef70823          	sb	a5,-16(a4)
 814:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 818:	02e05863          	blez	a4,848 <printint+0x94>
 81c:	fc040793          	addi	a5,s0,-64
 820:	00e78933          	add	s2,a5,a4
 824:	fff78993          	addi	s3,a5,-1
 828:	99ba                	add	s3,s3,a4
 82a:	377d                	addiw	a4,a4,-1
 82c:	1702                	slli	a4,a4,0x20
 82e:	9301                	srli	a4,a4,0x20
 830:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 834:	fff94583          	lbu	a1,-1(s2)
 838:	8526                	mv	a0,s1
 83a:	00000097          	auipc	ra,0x0
 83e:	f58080e7          	jalr	-168(ra) # 792 <putc>
  while(--i >= 0)
 842:	197d                	addi	s2,s2,-1
 844:	ff3918e3          	bne	s2,s3,834 <printint+0x80>
}
 848:	70e2                	ld	ra,56(sp)
 84a:	7442                	ld	s0,48(sp)
 84c:	74a2                	ld	s1,40(sp)
 84e:	7902                	ld	s2,32(sp)
 850:	69e2                	ld	s3,24(sp)
 852:	6121                	addi	sp,sp,64
 854:	8082                	ret
    x = -xx;
 856:	40b005bb          	negw	a1,a1
    neg = 1;
 85a:	4885                	li	a7,1
    x = -xx;
 85c:	bf8d                	j	7ce <printint+0x1a>

000000000000085e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 85e:	7119                	addi	sp,sp,-128
 860:	fc86                	sd	ra,120(sp)
 862:	f8a2                	sd	s0,112(sp)
 864:	f4a6                	sd	s1,104(sp)
 866:	f0ca                	sd	s2,96(sp)
 868:	ecce                	sd	s3,88(sp)
 86a:	e8d2                	sd	s4,80(sp)
 86c:	e4d6                	sd	s5,72(sp)
 86e:	e0da                	sd	s6,64(sp)
 870:	fc5e                	sd	s7,56(sp)
 872:	f862                	sd	s8,48(sp)
 874:	f466                	sd	s9,40(sp)
 876:	f06a                	sd	s10,32(sp)
 878:	ec6e                	sd	s11,24(sp)
 87a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 87c:	0005c903          	lbu	s2,0(a1)
 880:	18090f63          	beqz	s2,a1e <vprintf+0x1c0>
 884:	8aaa                	mv	s5,a0
 886:	8b32                	mv	s6,a2
 888:	00158493          	addi	s1,a1,1
  state = 0;
 88c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 88e:	02500a13          	li	s4,37
      if(c == 'd'){
 892:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 896:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 89a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 89e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a2:	00000b97          	auipc	s7,0x0
 8a6:	476b8b93          	addi	s7,s7,1142 # d18 <digits>
 8aa:	a839                	j	8c8 <vprintf+0x6a>
        putc(fd, c);
 8ac:	85ca                	mv	a1,s2
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	ee2080e7          	jalr	-286(ra) # 792 <putc>
 8b8:	a019                	j	8be <vprintf+0x60>
    } else if(state == '%'){
 8ba:	01498f63          	beq	s3,s4,8d8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8be:	0485                	addi	s1,s1,1
 8c0:	fff4c903          	lbu	s2,-1(s1)
 8c4:	14090d63          	beqz	s2,a1e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8c8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8cc:	fe0997e3          	bnez	s3,8ba <vprintf+0x5c>
      if(c == '%'){
 8d0:	fd479ee3          	bne	a5,s4,8ac <vprintf+0x4e>
        state = '%';
 8d4:	89be                	mv	s3,a5
 8d6:	b7e5                	j	8be <vprintf+0x60>
      if(c == 'd'){
 8d8:	05878063          	beq	a5,s8,918 <vprintf+0xba>
      } else if(c == 'l') {
 8dc:	05978c63          	beq	a5,s9,934 <vprintf+0xd6>
      } else if(c == 'x') {
 8e0:	07a78863          	beq	a5,s10,950 <vprintf+0xf2>
      } else if(c == 'p') {
 8e4:	09b78463          	beq	a5,s11,96c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8e8:	07300713          	li	a4,115
 8ec:	0ce78663          	beq	a5,a4,9b8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8f0:	06300713          	li	a4,99
 8f4:	0ee78e63          	beq	a5,a4,9f0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8f8:	11478863          	beq	a5,s4,a08 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8fc:	85d2                	mv	a1,s4
 8fe:	8556                	mv	a0,s5
 900:	00000097          	auipc	ra,0x0
 904:	e92080e7          	jalr	-366(ra) # 792 <putc>
        putc(fd, c);
 908:	85ca                	mv	a1,s2
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	e86080e7          	jalr	-378(ra) # 792 <putc>
      }
      state = 0;
 914:	4981                	li	s3,0
 916:	b765                	j	8be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 918:	008b0913          	addi	s2,s6,8
 91c:	4685                	li	a3,1
 91e:	4629                	li	a2,10
 920:	000b2583          	lw	a1,0(s6)
 924:	8556                	mv	a0,s5
 926:	00000097          	auipc	ra,0x0
 92a:	e8e080e7          	jalr	-370(ra) # 7b4 <printint>
 92e:	8b4a                	mv	s6,s2
      state = 0;
 930:	4981                	li	s3,0
 932:	b771                	j	8be <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 934:	008b0913          	addi	s2,s6,8
 938:	4681                	li	a3,0
 93a:	4629                	li	a2,10
 93c:	000b2583          	lw	a1,0(s6)
 940:	8556                	mv	a0,s5
 942:	00000097          	auipc	ra,0x0
 946:	e72080e7          	jalr	-398(ra) # 7b4 <printint>
 94a:	8b4a                	mv	s6,s2
      state = 0;
 94c:	4981                	li	s3,0
 94e:	bf85                	j	8be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 950:	008b0913          	addi	s2,s6,8
 954:	4681                	li	a3,0
 956:	4641                	li	a2,16
 958:	000b2583          	lw	a1,0(s6)
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	e56080e7          	jalr	-426(ra) # 7b4 <printint>
 966:	8b4a                	mv	s6,s2
      state = 0;
 968:	4981                	li	s3,0
 96a:	bf91                	j	8be <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 96c:	008b0793          	addi	a5,s6,8
 970:	f8f43423          	sd	a5,-120(s0)
 974:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 978:	03000593          	li	a1,48
 97c:	8556                	mv	a0,s5
 97e:	00000097          	auipc	ra,0x0
 982:	e14080e7          	jalr	-492(ra) # 792 <putc>
  putc(fd, 'x');
 986:	85ea                	mv	a1,s10
 988:	8556                	mv	a0,s5
 98a:	00000097          	auipc	ra,0x0
 98e:	e08080e7          	jalr	-504(ra) # 792 <putc>
 992:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 994:	03c9d793          	srli	a5,s3,0x3c
 998:	97de                	add	a5,a5,s7
 99a:	0007c583          	lbu	a1,0(a5)
 99e:	8556                	mv	a0,s5
 9a0:	00000097          	auipc	ra,0x0
 9a4:	df2080e7          	jalr	-526(ra) # 792 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9a8:	0992                	slli	s3,s3,0x4
 9aa:	397d                	addiw	s2,s2,-1
 9ac:	fe0914e3          	bnez	s2,994 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9b0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9b4:	4981                	li	s3,0
 9b6:	b721                	j	8be <vprintf+0x60>
        s = va_arg(ap, char*);
 9b8:	008b0993          	addi	s3,s6,8
 9bc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9c0:	02090163          	beqz	s2,9e2 <vprintf+0x184>
        while(*s != 0){
 9c4:	00094583          	lbu	a1,0(s2)
 9c8:	c9a1                	beqz	a1,a18 <vprintf+0x1ba>
          putc(fd, *s);
 9ca:	8556                	mv	a0,s5
 9cc:	00000097          	auipc	ra,0x0
 9d0:	dc6080e7          	jalr	-570(ra) # 792 <putc>
          s++;
 9d4:	0905                	addi	s2,s2,1
        while(*s != 0){
 9d6:	00094583          	lbu	a1,0(s2)
 9da:	f9e5                	bnez	a1,9ca <vprintf+0x16c>
        s = va_arg(ap, char*);
 9dc:	8b4e                	mv	s6,s3
      state = 0;
 9de:	4981                	li	s3,0
 9e0:	bdf9                	j	8be <vprintf+0x60>
          s = "(null)";
 9e2:	00000917          	auipc	s2,0x0
 9e6:	32e90913          	addi	s2,s2,814 # d10 <malloc+0x1e8>
        while(*s != 0){
 9ea:	02800593          	li	a1,40
 9ee:	bff1                	j	9ca <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9f0:	008b0913          	addi	s2,s6,8
 9f4:	000b4583          	lbu	a1,0(s6)
 9f8:	8556                	mv	a0,s5
 9fa:	00000097          	auipc	ra,0x0
 9fe:	d98080e7          	jalr	-616(ra) # 792 <putc>
 a02:	8b4a                	mv	s6,s2
      state = 0;
 a04:	4981                	li	s3,0
 a06:	bd65                	j	8be <vprintf+0x60>
        putc(fd, c);
 a08:	85d2                	mv	a1,s4
 a0a:	8556                	mv	a0,s5
 a0c:	00000097          	auipc	ra,0x0
 a10:	d86080e7          	jalr	-634(ra) # 792 <putc>
      state = 0;
 a14:	4981                	li	s3,0
 a16:	b565                	j	8be <vprintf+0x60>
        s = va_arg(ap, char*);
 a18:	8b4e                	mv	s6,s3
      state = 0;
 a1a:	4981                	li	s3,0
 a1c:	b54d                	j	8be <vprintf+0x60>
    }
  }
}
 a1e:	70e6                	ld	ra,120(sp)
 a20:	7446                	ld	s0,112(sp)
 a22:	74a6                	ld	s1,104(sp)
 a24:	7906                	ld	s2,96(sp)
 a26:	69e6                	ld	s3,88(sp)
 a28:	6a46                	ld	s4,80(sp)
 a2a:	6aa6                	ld	s5,72(sp)
 a2c:	6b06                	ld	s6,64(sp)
 a2e:	7be2                	ld	s7,56(sp)
 a30:	7c42                	ld	s8,48(sp)
 a32:	7ca2                	ld	s9,40(sp)
 a34:	7d02                	ld	s10,32(sp)
 a36:	6de2                	ld	s11,24(sp)
 a38:	6109                	addi	sp,sp,128
 a3a:	8082                	ret

0000000000000a3c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a3c:	715d                	addi	sp,sp,-80
 a3e:	ec06                	sd	ra,24(sp)
 a40:	e822                	sd	s0,16(sp)
 a42:	1000                	addi	s0,sp,32
 a44:	e010                	sd	a2,0(s0)
 a46:	e414                	sd	a3,8(s0)
 a48:	e818                	sd	a4,16(s0)
 a4a:	ec1c                	sd	a5,24(s0)
 a4c:	03043023          	sd	a6,32(s0)
 a50:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a54:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a58:	8622                	mv	a2,s0
 a5a:	00000097          	auipc	ra,0x0
 a5e:	e04080e7          	jalr	-508(ra) # 85e <vprintf>
}
 a62:	60e2                	ld	ra,24(sp)
 a64:	6442                	ld	s0,16(sp)
 a66:	6161                	addi	sp,sp,80
 a68:	8082                	ret

0000000000000a6a <printf>:

void
printf(const char *fmt, ...)
{
 a6a:	711d                	addi	sp,sp,-96
 a6c:	ec06                	sd	ra,24(sp)
 a6e:	e822                	sd	s0,16(sp)
 a70:	1000                	addi	s0,sp,32
 a72:	e40c                	sd	a1,8(s0)
 a74:	e810                	sd	a2,16(s0)
 a76:	ec14                	sd	a3,24(s0)
 a78:	f018                	sd	a4,32(s0)
 a7a:	f41c                	sd	a5,40(s0)
 a7c:	03043823          	sd	a6,48(s0)
 a80:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a84:	00840613          	addi	a2,s0,8
 a88:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a8c:	85aa                	mv	a1,a0
 a8e:	4505                	li	a0,1
 a90:	00000097          	auipc	ra,0x0
 a94:	dce080e7          	jalr	-562(ra) # 85e <vprintf>
}
 a98:	60e2                	ld	ra,24(sp)
 a9a:	6442                	ld	s0,16(sp)
 a9c:	6125                	addi	sp,sp,96
 a9e:	8082                	ret

0000000000000aa0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aa0:	1141                	addi	sp,sp,-16
 aa2:	e422                	sd	s0,8(sp)
 aa4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aaa:	00000797          	auipc	a5,0x0
 aae:	2a67b783          	ld	a5,678(a5) # d50 <freep>
 ab2:	a805                	j	ae2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ab4:	4618                	lw	a4,8(a2)
 ab6:	9db9                	addw	a1,a1,a4
 ab8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abc:	6398                	ld	a4,0(a5)
 abe:	6318                	ld	a4,0(a4)
 ac0:	fee53823          	sd	a4,-16(a0)
 ac4:	a091                	j	b08 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ac6:	ff852703          	lw	a4,-8(a0)
 aca:	9e39                	addw	a2,a2,a4
 acc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ace:	ff053703          	ld	a4,-16(a0)
 ad2:	e398                	sd	a4,0(a5)
 ad4:	a099                	j	b1a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad6:	6398                	ld	a4,0(a5)
 ad8:	00e7e463          	bltu	a5,a4,ae0 <free+0x40>
 adc:	00e6ea63          	bltu	a3,a4,af0 <free+0x50>
{
 ae0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae2:	fed7fae3          	bgeu	a5,a3,ad6 <free+0x36>
 ae6:	6398                	ld	a4,0(a5)
 ae8:	00e6e463          	bltu	a3,a4,af0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aec:	fee7eae3          	bltu	a5,a4,ae0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 af0:	ff852583          	lw	a1,-8(a0)
 af4:	6390                	ld	a2,0(a5)
 af6:	02059713          	slli	a4,a1,0x20
 afa:	9301                	srli	a4,a4,0x20
 afc:	0712                	slli	a4,a4,0x4
 afe:	9736                	add	a4,a4,a3
 b00:	fae60ae3          	beq	a2,a4,ab4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 b04:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b08:	4790                	lw	a2,8(a5)
 b0a:	02061713          	slli	a4,a2,0x20
 b0e:	9301                	srli	a4,a4,0x20
 b10:	0712                	slli	a4,a4,0x4
 b12:	973e                	add	a4,a4,a5
 b14:	fae689e3          	beq	a3,a4,ac6 <free+0x26>
  } else
    p->s.ptr = bp;
 b18:	e394                	sd	a3,0(a5)
  freep = p;
 b1a:	00000717          	auipc	a4,0x0
 b1e:	22f73b23          	sd	a5,566(a4) # d50 <freep>
}
 b22:	6422                	ld	s0,8(sp)
 b24:	0141                	addi	sp,sp,16
 b26:	8082                	ret

0000000000000b28 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b28:	7139                	addi	sp,sp,-64
 b2a:	fc06                	sd	ra,56(sp)
 b2c:	f822                	sd	s0,48(sp)
 b2e:	f426                	sd	s1,40(sp)
 b30:	f04a                	sd	s2,32(sp)
 b32:	ec4e                	sd	s3,24(sp)
 b34:	e852                	sd	s4,16(sp)
 b36:	e456                	sd	s5,8(sp)
 b38:	e05a                	sd	s6,0(sp)
 b3a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b3c:	02051493          	slli	s1,a0,0x20
 b40:	9081                	srli	s1,s1,0x20
 b42:	04bd                	addi	s1,s1,15
 b44:	8091                	srli	s1,s1,0x4
 b46:	0014899b          	addiw	s3,s1,1
 b4a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b4c:	00000517          	auipc	a0,0x0
 b50:	20453503          	ld	a0,516(a0) # d50 <freep>
 b54:	c515                	beqz	a0,b80 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b56:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b58:	4798                	lw	a4,8(a5)
 b5a:	02977f63          	bgeu	a4,s1,b98 <malloc+0x70>
 b5e:	8a4e                	mv	s4,s3
 b60:	0009871b          	sext.w	a4,s3
 b64:	6685                	lui	a3,0x1
 b66:	00d77363          	bgeu	a4,a3,b6c <malloc+0x44>
 b6a:	6a05                	lui	s4,0x1
 b6c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b70:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b74:	00000917          	auipc	s2,0x0
 b78:	1dc90913          	addi	s2,s2,476 # d50 <freep>
  if(p == (char*)-1)
 b7c:	5afd                	li	s5,-1
 b7e:	a88d                	j	bf0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b80:	00008797          	auipc	a5,0x8
 b84:	3d878793          	addi	a5,a5,984 # 8f58 <base>
 b88:	00000717          	auipc	a4,0x0
 b8c:	1cf73423          	sd	a5,456(a4) # d50 <freep>
 b90:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b92:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b96:	b7e1                	j	b5e <malloc+0x36>
      if(p->s.size == nunits)
 b98:	02e48b63          	beq	s1,a4,bce <malloc+0xa6>
        p->s.size -= nunits;
 b9c:	4137073b          	subw	a4,a4,s3
 ba0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ba2:	1702                	slli	a4,a4,0x20
 ba4:	9301                	srli	a4,a4,0x20
 ba6:	0712                	slli	a4,a4,0x4
 ba8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 baa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bae:	00000717          	auipc	a4,0x0
 bb2:	1aa73123          	sd	a0,418(a4) # d50 <freep>
      return (void*)(p + 1);
 bb6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bba:	70e2                	ld	ra,56(sp)
 bbc:	7442                	ld	s0,48(sp)
 bbe:	74a2                	ld	s1,40(sp)
 bc0:	7902                	ld	s2,32(sp)
 bc2:	69e2                	ld	s3,24(sp)
 bc4:	6a42                	ld	s4,16(sp)
 bc6:	6aa2                	ld	s5,8(sp)
 bc8:	6b02                	ld	s6,0(sp)
 bca:	6121                	addi	sp,sp,64
 bcc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bce:	6398                	ld	a4,0(a5)
 bd0:	e118                	sd	a4,0(a0)
 bd2:	bff1                	j	bae <malloc+0x86>
  hp->s.size = nu;
 bd4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bd8:	0541                	addi	a0,a0,16
 bda:	00000097          	auipc	ra,0x0
 bde:	ec6080e7          	jalr	-314(ra) # aa0 <free>
  return freep;
 be2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 be6:	d971                	beqz	a0,bba <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bea:	4798                	lw	a4,8(a5)
 bec:	fa9776e3          	bgeu	a4,s1,b98 <malloc+0x70>
    if(p == freep)
 bf0:	00093703          	ld	a4,0(s2)
 bf4:	853e                	mv	a0,a5
 bf6:	fef719e3          	bne	a4,a5,be8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 bfa:	8552                	mv	a0,s4
 bfc:	00000097          	auipc	ra,0x0
 c00:	b7e080e7          	jalr	-1154(ra) # 77a <sbrk>
  if(p == (char*)-1)
 c04:	fd5518e3          	bne	a0,s5,bd4 <malloc+0xac>
        return 0;
 c08:	4501                	li	a0,0
 c0a:	bf45                	j	bba <malloc+0x92>
