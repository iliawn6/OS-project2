
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c3010113          	addi	sp,sp,-976 # 80019c30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6c8050ef          	jal	ra,800056de <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d0078793          	addi	a5,a5,-768 # 80021d30 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	87090913          	addi	s2,s2,-1936 # 800088c0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	070080e7          	jalr	112(ra) # 800060ca <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	110080e7          	jalr	272(ra) # 8000617e <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b04080e7          	jalr	-1276(ra) # 80005b8e <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00008517          	auipc	a0,0x8
    800000f0:	7d450513          	addi	a0,a0,2004 # 800088c0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	f46080e7          	jalr	-186(ra) # 8000603a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	c3050513          	addi	a0,a0,-976 # 80021d30 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00008497          	auipc	s1,0x8
    80000126:	79e48493          	addi	s1,s1,1950 # 800088c0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	f9e080e7          	jalr	-98(ra) # 800060ca <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	78650513          	addi	a0,a0,1926 # 800088c0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	03a080e7          	jalr	58(ra) # 8000617e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	75a50513          	addi	a0,a0,1882 # 800088c0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	010080e7          	jalr	16(ra) # 8000617e <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ca19                	beqz	a2,80000194 <memset+0x1c>
    80000180:	87aa                	mv	a5,a0
    80000182:	1602                	slli	a2,a2,0x20
    80000184:	9201                	srli	a2,a2,0x20
    80000186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018e:	0785                	addi	a5,a5,1
    80000190:	fee79de3          	bne	a5,a4,8000018a <memset+0x12>
  }
  return dst;
}
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret

000000008000019a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a0:	ca05                	beqz	a2,800001d0 <memcmp+0x36>
    800001a2:	fff6069b          	addiw	a3,a2,-1
    800001a6:	1682                	slli	a3,a3,0x20
    800001a8:	9281                	srli	a3,a3,0x20
    800001aa:	0685                	addi	a3,a3,1
    800001ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ae:	00054783          	lbu	a5,0(a0)
    800001b2:	0005c703          	lbu	a4,0(a1)
    800001b6:	00e79863          	bne	a5,a4,800001c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001ba:	0505                	addi	a0,a0,1
    800001bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001be:	fed518e3          	bne	a0,a3,800001ae <memcmp+0x14>
  }

  return 0;
    800001c2:	4501                	li	a0,0
    800001c4:	a019                	j	800001ca <memcmp+0x30>
      return *s1 - *s2;
    800001c6:	40e7853b          	subw	a0,a5,a4
}
    800001ca:	6422                	ld	s0,8(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret
  return 0;
    800001d0:	4501                	li	a0,0
    800001d2:	bfe5                	j	800001ca <memcmp+0x30>

00000000800001d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001da:	c205                	beqz	a2,800001fa <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001dc:	02a5e263          	bltu	a1,a0,80000200 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e0:	1602                	slli	a2,a2,0x20
    800001e2:	9201                	srli	a2,a2,0x20
    800001e4:	00c587b3          	add	a5,a1,a2
{
    800001e8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ea:	0585                	addi	a1,a1,1
    800001ec:	0705                	addi	a4,a4,1
    800001ee:	fff5c683          	lbu	a3,-1(a1)
    800001f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f6:	fef59ae3          	bne	a1,a5,800001ea <memmove+0x16>

  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret
  if(s < d && s + n > d){
    80000200:	02061693          	slli	a3,a2,0x20
    80000204:	9281                	srli	a3,a3,0x20
    80000206:	00d58733          	add	a4,a1,a3
    8000020a:	fce57be3          	bgeu	a0,a4,800001e0 <memmove+0xc>
    d += n;
    8000020e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000210:	fff6079b          	addiw	a5,a2,-1
    80000214:	1782                	slli	a5,a5,0x20
    80000216:	9381                	srli	a5,a5,0x20
    80000218:	fff7c793          	not	a5,a5
    8000021c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021e:	177d                	addi	a4,a4,-1
    80000220:	16fd                	addi	a3,a3,-1
    80000222:	00074603          	lbu	a2,0(a4)
    80000226:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022a:	fee79ae3          	bne	a5,a4,8000021e <memmove+0x4a>
    8000022e:	b7f1                	j	800001fa <memmove+0x26>

0000000080000230 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e406                	sd	ra,8(sp)
    80000234:	e022                	sd	s0,0(sp)
    80000236:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	f9c080e7          	jalr	-100(ra) # 800001d4 <memmove>
}
    80000240:	60a2                	ld	ra,8(sp)
    80000242:	6402                	ld	s0,0(sp)
    80000244:	0141                	addi	sp,sp,16
    80000246:	8082                	ret

0000000080000248 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e422                	sd	s0,8(sp)
    8000024c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000024e:	ce11                	beqz	a2,8000026a <strncmp+0x22>
    80000250:	00054783          	lbu	a5,0(a0)
    80000254:	cf89                	beqz	a5,8000026e <strncmp+0x26>
    80000256:	0005c703          	lbu	a4,0(a1)
    8000025a:	00f71a63          	bne	a4,a5,8000026e <strncmp+0x26>
    n--, p++, q++;
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	0505                	addi	a0,a0,1
    80000262:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000264:	f675                	bnez	a2,80000250 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000266:	4501                	li	a0,0
    80000268:	a809                	j	8000027a <strncmp+0x32>
    8000026a:	4501                	li	a0,0
    8000026c:	a039                	j	8000027a <strncmp+0x32>
  if(n == 0)
    8000026e:	ca09                	beqz	a2,80000280 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
    return 0;
    80000280:	4501                	li	a0,0
    80000282:	bfe5                	j	8000027a <strncmp+0x32>

0000000080000284 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028a:	872a                	mv	a4,a0
    8000028c:	8832                	mv	a6,a2
    8000028e:	367d                	addiw	a2,a2,-1
    80000290:	01005963          	blez	a6,800002a2 <strncpy+0x1e>
    80000294:	0705                	addi	a4,a4,1
    80000296:	0005c783          	lbu	a5,0(a1)
    8000029a:	fef70fa3          	sb	a5,-1(a4)
    8000029e:	0585                	addi	a1,a1,1
    800002a0:	f7f5                	bnez	a5,8000028c <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a2:	86ba                	mv	a3,a4
    800002a4:	00c05c63          	blez	a2,800002bc <strncpy+0x38>
    *s++ = 0;
    800002a8:	0685                	addi	a3,a3,1
    800002aa:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002ae:	fff6c793          	not	a5,a3
    800002b2:	9fb9                	addw	a5,a5,a4
    800002b4:	010787bb          	addw	a5,a5,a6
    800002b8:	fef048e3          	bgtz	a5,800002a8 <strncpy+0x24>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	4685                	li	a3,1
    80000306:	9e89                	subw	a3,a3,a0
    80000308:	00f6853b          	addw	a0,a3,a5
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff7c703          	lbu	a4,-1(a5)
    80000312:	fb7d                	bnez	a4,80000308 <strlen+0x14>
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	b00080e7          	jalr	-1280(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	56270713          	addi	a4,a4,1378 # 80008890 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	ae4080e7          	jalr	-1308(ra) # 80000e26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	884080e7          	jalr	-1916(ra) # 80005bd8 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	78a080e7          	jalr	1930(ra) # 80001aee <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	d24080e7          	jalr	-732(ra) # 80005090 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fd4080e7          	jalr	-44(ra) # 80001348 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	724080e7          	jalr	1828(ra) # 80005aa0 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a34080e7          	jalr	-1484(ra) # 80005db8 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	844080e7          	jalr	-1980(ra) # 80005bd8 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	834080e7          	jalr	-1996(ra) # 80005bd8 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	824080e7          	jalr	-2012(ra) # 80005bd8 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d20080e7          	jalr	-736(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	99e080e7          	jalr	-1634(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	6ea080e7          	jalr	1770(ra) # 80001ac6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	70a080e7          	jalr	1802(ra) # 80001aee <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	c8e080e7          	jalr	-882(ra) # 8000507a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c9c080e7          	jalr	-868(ra) # 80005090 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e3c080e7          	jalr	-452(ra) # 80002238 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	4e0080e7          	jalr	1248(ra) # 800028e4 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	47e080e7          	jalr	1150(ra) # 8000388a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	d84080e7          	jalr	-636(ra) # 80005198 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0e080e7          	jalr	-754(ra) # 8000112a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	46f72323          	sw	a5,1126(a4) # 80008890 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	45a7b783          	ld	a5,1114(a5) # 80008898 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	704080e7          	jalr	1796(ra) # 80005b8e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c82080e7          	jalr	-894(ra) # 80000118 <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd2080e7          	jalr	-814(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	00a7d513          	srli	a0,a5,0xa
    8000053c:	0532                	slli	a0,a0,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	77fd                	lui	a5,0xfffff
    80000562:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000566:	15fd                	addi	a1,a1,-1
    80000568:	00c589b3          	add	s3,a1,a2
    8000056c:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000570:	8952                	mv	s2,s4
    80000572:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	5de080e7          	jalr	1502(ra) # 80005b8e <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	5ce080e7          	jalr	1486(ra) # 80005b8e <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	582080e7          	jalr	1410(ra) # 80005b8e <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	af8080e7          	jalr	-1288(ra) # 80000118 <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4a080e7          	jalr	-1206(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	18a7bf23          	sd	a0,414(a5) # 80008898 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	436080e7          	jalr	1078(ra) # 80005b8e <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	426080e7          	jalr	1062(ra) # 80005b8e <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	416080e7          	jalr	1046(ra) # 80005b8e <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	406080e7          	jalr	1030(ra) # 80005b8e <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	940080e7          	jalr	-1728(ra) # 80000118 <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	990080e7          	jalr	-1648(ra) # 80000178 <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	900080e7          	jalr	-1792(ra) # 80000118 <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	952080e7          	jalr	-1710(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	98e080e7          	jalr	-1650(ra) # 800001d4 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	328080e7          	jalr	808(ra) # 80005b8e <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	767d                	lui	a2,0xfffff
    8000088a:	8f71                	and	a4,a4,a2
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff1                	and	a5,a5,a2
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6985                	lui	s3,0x1
    800008d4:	19fd                	addi	s3,s3,-1
    800008d6:	95ce                	add	a1,a1,s3
    800008d8:	79fd                	lui	s3,0xfffff
    800008da:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	830080e7          	jalr	-2000(ra) # 80000118 <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	880080e7          	jalr	-1920(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a821                	j	8000099a <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000986:	0532                	slli	a0,a0,0xc
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	fe0080e7          	jalr	-32(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000990:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000994:	04a1                	addi	s1,s1,8
    80000996:	03248163          	beq	s1,s2,800009b8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000099a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099c:	00f57793          	andi	a5,a0,15
    800009a0:	ff3782e3          	beq	a5,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a4:	8905                	andi	a0,a0,1
    800009a6:	d57d                	beqz	a0,80000994 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a8:	00007517          	auipc	a0,0x7
    800009ac:	75050513          	addi	a0,a0,1872 # 800080f8 <etext+0xf8>
    800009b0:	00005097          	auipc	ra,0x5
    800009b4:	1de080e7          	jalr	478(ra) # 80005b8e <panic>
    }
  }
  kfree((void*)pagetable);
    800009b8:	8552                	mv	a0,s4
    800009ba:	fffff097          	auipc	ra,0xfffff
    800009be:	662080e7          	jalr	1634(ra) # 8000001c <kfree>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret

00000000800009d2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d2:	1101                	addi	sp,sp,-32
    800009d4:	ec06                	sd	ra,24(sp)
    800009d6:	e822                	sd	s0,16(sp)
    800009d8:	e426                	sd	s1,8(sp)
    800009da:	1000                	addi	s0,sp,32
    800009dc:	84aa                	mv	s1,a0
  if(sz > 0)
    800009de:	e999                	bnez	a1,800009f4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e0:	8526                	mv	a0,s1
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	f86080e7          	jalr	-122(ra) # 80000968 <freewalk>
}
    800009ea:	60e2                	ld	ra,24(sp)
    800009ec:	6442                	ld	s0,16(sp)
    800009ee:	64a2                	ld	s1,8(sp)
    800009f0:	6105                	addi	sp,sp,32
    800009f2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f4:	6605                	lui	a2,0x1
    800009f6:	167d                	addi	a2,a2,-1
    800009f8:	962e                	add	a2,a2,a1
    800009fa:	4685                	li	a3,1
    800009fc:	8231                	srli	a2,a2,0xc
    800009fe:	4581                	li	a1,0
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	d0a080e7          	jalr	-758(ra) # 8000070a <uvmunmap>
    80000a08:	bfe1                	j	800009e0 <uvmfree+0xe>

0000000080000a0a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0a:	c679                	beqz	a2,80000ad8 <uvmcopy+0xce>
{
    80000a0c:	715d                	addi	sp,sp,-80
    80000a0e:	e486                	sd	ra,72(sp)
    80000a10:	e0a2                	sd	s0,64(sp)
    80000a12:	fc26                	sd	s1,56(sp)
    80000a14:	f84a                	sd	s2,48(sp)
    80000a16:	f44e                	sd	s3,40(sp)
    80000a18:	f052                	sd	s4,32(sp)
    80000a1a:	ec56                	sd	s5,24(sp)
    80000a1c:	e85a                	sd	s6,16(sp)
    80000a1e:	e45e                	sd	s7,8(sp)
    80000a20:	0880                	addi	s0,sp,80
    80000a22:	8b2a                	mv	s6,a0
    80000a24:	8aae                	mv	s5,a1
    80000a26:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a28:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2a:	4601                	li	a2,0
    80000a2c:	85ce                	mv	a1,s3
    80000a2e:	855a                	mv	a0,s6
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	a2c080e7          	jalr	-1492(ra) # 8000045c <walk>
    80000a38:	c531                	beqz	a0,80000a84 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3a:	6118                	ld	a4,0(a0)
    80000a3c:	00177793          	andi	a5,a4,1
    80000a40:	cbb1                	beqz	a5,80000a94 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a42:	00a75593          	srli	a1,a4,0xa
    80000a46:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4e:	fffff097          	auipc	ra,0xfffff
    80000a52:	6ca080e7          	jalr	1738(ra) # 80000118 <kalloc>
    80000a56:	892a                	mv	s2,a0
    80000a58:	c939                	beqz	a0,80000aae <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	85de                	mv	a1,s7
    80000a5e:	fffff097          	auipc	ra,0xfffff
    80000a62:	776080e7          	jalr	1910(ra) # 800001d4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a66:	8726                	mv	a4,s1
    80000a68:	86ca                	mv	a3,s2
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	85ce                	mv	a1,s3
    80000a6e:	8556                	mv	a0,s5
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	ad4080e7          	jalr	-1324(ra) # 80000544 <mappages>
    80000a78:	e515                	bnez	a0,80000aa4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	99be                	add	s3,s3,a5
    80000a7e:	fb49e6e3          	bltu	s3,s4,80000a2a <uvmcopy+0x20>
    80000a82:	a081                	j	80000ac2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a84:	00007517          	auipc	a0,0x7
    80000a88:	68450513          	addi	a0,a0,1668 # 80008108 <etext+0x108>
    80000a8c:	00005097          	auipc	ra,0x5
    80000a90:	102080e7          	jalr	258(ra) # 80005b8e <panic>
      panic("uvmcopy: page not present");
    80000a94:	00007517          	auipc	a0,0x7
    80000a98:	69450513          	addi	a0,a0,1684 # 80008128 <etext+0x128>
    80000a9c:	00005097          	auipc	ra,0x5
    80000aa0:	0f2080e7          	jalr	242(ra) # 80005b8e <panic>
      kfree(mem);
    80000aa4:	854a                	mv	a0,s2
    80000aa6:	fffff097          	auipc	ra,0xfffff
    80000aaa:	576080e7          	jalr	1398(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aae:	4685                	li	a3,1
    80000ab0:	00c9d613          	srli	a2,s3,0xc
    80000ab4:	4581                	li	a1,0
    80000ab6:	8556                	mv	a0,s5
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	c52080e7          	jalr	-942(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac0:	557d                	li	a0,-1
}
    80000ac2:	60a6                	ld	ra,72(sp)
    80000ac4:	6406                	ld	s0,64(sp)
    80000ac6:	74e2                	ld	s1,56(sp)
    80000ac8:	7942                	ld	s2,48(sp)
    80000aca:	79a2                	ld	s3,40(sp)
    80000acc:	7a02                	ld	s4,32(sp)
    80000ace:	6ae2                	ld	s5,24(sp)
    80000ad0:	6b42                	ld	s6,16(sp)
    80000ad2:	6ba2                	ld	s7,8(sp)
    80000ad4:	6161                	addi	sp,sp,80
    80000ad6:	8082                	ret
  return 0;
    80000ad8:	4501                	li	a0,0
}
    80000ada:	8082                	ret

0000000080000adc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000adc:	1141                	addi	sp,sp,-16
    80000ade:	e406                	sd	ra,8(sp)
    80000ae0:	e022                	sd	s0,0(sp)
    80000ae2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae4:	4601                	li	a2,0
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	976080e7          	jalr	-1674(ra) # 8000045c <walk>
  if(pte == 0)
    80000aee:	c901                	beqz	a0,80000afe <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af0:	611c                	ld	a5,0(a0)
    80000af2:	9bbd                	andi	a5,a5,-17
    80000af4:	e11c                	sd	a5,0(a0)
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret
    panic("uvmclear");
    80000afe:	00007517          	auipc	a0,0x7
    80000b02:	64a50513          	addi	a0,a0,1610 # 80008148 <etext+0x148>
    80000b06:	00005097          	auipc	ra,0x5
    80000b0a:	088080e7          	jalr	136(ra) # 80005b8e <panic>

0000000080000b0e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0e:	c6bd                	beqz	a3,80000b7c <copyout+0x6e>
{
    80000b10:	715d                	addi	sp,sp,-80
    80000b12:	e486                	sd	ra,72(sp)
    80000b14:	e0a2                	sd	s0,64(sp)
    80000b16:	fc26                	sd	s1,56(sp)
    80000b18:	f84a                	sd	s2,48(sp)
    80000b1a:	f44e                	sd	s3,40(sp)
    80000b1c:	f052                	sd	s4,32(sp)
    80000b1e:	ec56                	sd	s5,24(sp)
    80000b20:	e85a                	sd	s6,16(sp)
    80000b22:	e45e                	sd	s7,8(sp)
    80000b24:	e062                	sd	s8,0(sp)
    80000b26:	0880                	addi	s0,sp,80
    80000b28:	8b2a                	mv	s6,a0
    80000b2a:	8c2e                	mv	s8,a1
    80000b2c:	8a32                	mv	s4,a2
    80000b2e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b30:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b32:	6a85                	lui	s5,0x1
    80000b34:	a015                	j	80000b58 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b36:	9562                	add	a0,a0,s8
    80000b38:	0004861b          	sext.w	a2,s1
    80000b3c:	85d2                	mv	a1,s4
    80000b3e:	41250533          	sub	a0,a0,s2
    80000b42:	fffff097          	auipc	ra,0xfffff
    80000b46:	692080e7          	jalr	1682(ra) # 800001d4 <memmove>

    len -= n;
    80000b4a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b50:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b54:	02098263          	beqz	s3,80000b78 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b58:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b5c:	85ca                	mv	a1,s2
    80000b5e:	855a                	mv	a0,s6
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	9a2080e7          	jalr	-1630(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b68:	cd01                	beqz	a0,80000b80 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6a:	418904b3          	sub	s1,s2,s8
    80000b6e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b70:	fc99f3e3          	bgeu	s3,s1,80000b36 <copyout+0x28>
    80000b74:	84ce                	mv	s1,s3
    80000b76:	b7c1                	j	80000b36 <copyout+0x28>
  }
  return 0;
    80000b78:	4501                	li	a0,0
    80000b7a:	a021                	j	80000b82 <copyout+0x74>
    80000b7c:	4501                	li	a0,0
}
    80000b7e:	8082                	ret
      return -1;
    80000b80:	557d                	li	a0,-1
}
    80000b82:	60a6                	ld	ra,72(sp)
    80000b84:	6406                	ld	s0,64(sp)
    80000b86:	74e2                	ld	s1,56(sp)
    80000b88:	7942                	ld	s2,48(sp)
    80000b8a:	79a2                	ld	s3,40(sp)
    80000b8c:	7a02                	ld	s4,32(sp)
    80000b8e:	6ae2                	ld	s5,24(sp)
    80000b90:	6b42                	ld	s6,16(sp)
    80000b92:	6ba2                	ld	s7,8(sp)
    80000b94:	6c02                	ld	s8,0(sp)
    80000b96:	6161                	addi	sp,sp,80
    80000b98:	8082                	ret

0000000080000b9a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9a:	caa5                	beqz	a3,80000c0a <copyin+0x70>
{
    80000b9c:	715d                	addi	sp,sp,-80
    80000b9e:	e486                	sd	ra,72(sp)
    80000ba0:	e0a2                	sd	s0,64(sp)
    80000ba2:	fc26                	sd	s1,56(sp)
    80000ba4:	f84a                	sd	s2,48(sp)
    80000ba6:	f44e                	sd	s3,40(sp)
    80000ba8:	f052                	sd	s4,32(sp)
    80000baa:	ec56                	sd	s5,24(sp)
    80000bac:	e85a                	sd	s6,16(sp)
    80000bae:	e45e                	sd	s7,8(sp)
    80000bb0:	e062                	sd	s8,0(sp)
    80000bb2:	0880                	addi	s0,sp,80
    80000bb4:	8b2a                	mv	s6,a0
    80000bb6:	8a2e                	mv	s4,a1
    80000bb8:	8c32                	mv	s8,a2
    80000bba:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bbc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bbe:	6a85                	lui	s5,0x1
    80000bc0:	a01d                	j	80000be6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc2:	018505b3          	add	a1,a0,s8
    80000bc6:	0004861b          	sext.w	a2,s1
    80000bca:	412585b3          	sub	a1,a1,s2
    80000bce:	8552                	mv	a0,s4
    80000bd0:	fffff097          	auipc	ra,0xfffff
    80000bd4:	604080e7          	jalr	1540(ra) # 800001d4 <memmove>

    len -= n;
    80000bd8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bdc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bde:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be2:	02098263          	beqz	s3,80000c06 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bea:	85ca                	mv	a1,s2
    80000bec:	855a                	mv	a0,s6
    80000bee:	00000097          	auipc	ra,0x0
    80000bf2:	914080e7          	jalr	-1772(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bf6:	cd01                	beqz	a0,80000c0e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf8:	418904b3          	sub	s1,s2,s8
    80000bfc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bfe:	fc99f2e3          	bgeu	s3,s1,80000bc2 <copyin+0x28>
    80000c02:	84ce                	mv	s1,s3
    80000c04:	bf7d                	j	80000bc2 <copyin+0x28>
  }
  return 0;
    80000c06:	4501                	li	a0,0
    80000c08:	a021                	j	80000c10 <copyin+0x76>
    80000c0a:	4501                	li	a0,0
}
    80000c0c:	8082                	ret
      return -1;
    80000c0e:	557d                	li	a0,-1
}
    80000c10:	60a6                	ld	ra,72(sp)
    80000c12:	6406                	ld	s0,64(sp)
    80000c14:	74e2                	ld	s1,56(sp)
    80000c16:	7942                	ld	s2,48(sp)
    80000c18:	79a2                	ld	s3,40(sp)
    80000c1a:	7a02                	ld	s4,32(sp)
    80000c1c:	6ae2                	ld	s5,24(sp)
    80000c1e:	6b42                	ld	s6,16(sp)
    80000c20:	6ba2                	ld	s7,8(sp)
    80000c22:	6c02                	ld	s8,0(sp)
    80000c24:	6161                	addi	sp,sp,80
    80000c26:	8082                	ret

0000000080000c28 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c28:	c6c5                	beqz	a3,80000cd0 <copyinstr+0xa8>
{
    80000c2a:	715d                	addi	sp,sp,-80
    80000c2c:	e486                	sd	ra,72(sp)
    80000c2e:	e0a2                	sd	s0,64(sp)
    80000c30:	fc26                	sd	s1,56(sp)
    80000c32:	f84a                	sd	s2,48(sp)
    80000c34:	f44e                	sd	s3,40(sp)
    80000c36:	f052                	sd	s4,32(sp)
    80000c38:	ec56                	sd	s5,24(sp)
    80000c3a:	e85a                	sd	s6,16(sp)
    80000c3c:	e45e                	sd	s7,8(sp)
    80000c3e:	0880                	addi	s0,sp,80
    80000c40:	8a2a                	mv	s4,a0
    80000c42:	8b2e                	mv	s6,a1
    80000c44:	8bb2                	mv	s7,a2
    80000c46:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c48:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4a:	6985                	lui	s3,0x1
    80000c4c:	a035                	j	80000c78 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c4e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c52:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c54:	0017b793          	seqz	a5,a5
    80000c58:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5c:	60a6                	ld	ra,72(sp)
    80000c5e:	6406                	ld	s0,64(sp)
    80000c60:	74e2                	ld	s1,56(sp)
    80000c62:	7942                	ld	s2,48(sp)
    80000c64:	79a2                	ld	s3,40(sp)
    80000c66:	7a02                	ld	s4,32(sp)
    80000c68:	6ae2                	ld	s5,24(sp)
    80000c6a:	6b42                	ld	s6,16(sp)
    80000c6c:	6ba2                	ld	s7,8(sp)
    80000c6e:	6161                	addi	sp,sp,80
    80000c70:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c72:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c76:	c8a9                	beqz	s1,80000cc8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c78:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7c:	85ca                	mv	a1,s2
    80000c7e:	8552                	mv	a0,s4
    80000c80:	00000097          	auipc	ra,0x0
    80000c84:	882080e7          	jalr	-1918(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c88:	c131                	beqz	a0,80000ccc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c8a:	41790833          	sub	a6,s2,s7
    80000c8e:	984e                	add	a6,a6,s3
    if(n > max)
    80000c90:	0104f363          	bgeu	s1,a6,80000c96 <copyinstr+0x6e>
    80000c94:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c96:	955e                	add	a0,a0,s7
    80000c98:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9c:	fc080be3          	beqz	a6,80000c72 <copyinstr+0x4a>
    80000ca0:	985a                	add	a6,a6,s6
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	14fd                	addi	s1,s1,-1
    80000caa:	9b26                	add	s6,s6,s1
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4)
    80000cb4:	df49                	beqz	a4,80000c4e <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      --max;
    80000cba:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cbe:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc0:	ff0796e3          	bne	a5,a6,80000cac <copyinstr+0x84>
      dst++;
    80000cc4:	8b42                	mv	s6,a6
    80000cc6:	b775                	j	80000c72 <copyinstr+0x4a>
    80000cc8:	4781                	li	a5,0
    80000cca:	b769                	j	80000c54 <copyinstr+0x2c>
      return -1;
    80000ccc:	557d                	li	a0,-1
    80000cce:	b779                	j	80000c5c <copyinstr+0x34>
  int got_null = 0;
    80000cd0:	4781                	li	a5,0
  if(got_null){
    80000cd2:	0017b793          	seqz	a5,a5
    80000cd6:	40f00533          	neg	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	01e48493          	addi	s1,s1,30 # 80008d10 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	04000937          	lui	s2,0x4000
    80000d08:	197d                	addi	s2,s2,-1
    80000d0a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	a04a0a13          	addi	s4,s4,-1532 # 8000e710 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	404080e7          	jalr	1028(ra) # 80000118 <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c131                	beqz	a0,80000d62 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	858d                	srai	a1,a1,0x3
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	2585                	addiw	a1,a1,1
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a6080e7          	jalr	-1882(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	16848493          	addi	s1,s1,360
    80000d4a:	fd4495e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	e24080e7          	jalr	-476(ra) # 80005b8e <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	b5250513          	addi	a0,a0,-1198 # 800088e0 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	2a4080e7          	jalr	676(ra) # 8000603a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	b5250513          	addi	a0,a0,-1198 # 800088f8 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	28c080e7          	jalr	652(ra) # 8000603a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	f5a48493          	addi	s1,s1,-166 # 80008d10 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	04000937          	lui	s2,0x4000
    80000dd4:	197d                	addi	s2,s2,-1
    80000dd6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	0000e997          	auipc	s3,0xe
    80000ddc:	93898993          	addi	s3,s3,-1736 # 8000e710 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	256080e7          	jalr	598(ra) # 8000603a <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	878d                	srai	a5,a5,0x3
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	2785                	addiw	a5,a5,1
    80000e00:	00d7979b          	slliw	a5,a5,0xd
    80000e04:	40f907b3          	sub	a5,s2,a5
    80000e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	16848493          	addi	s1,s1,360
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	ace50513          	addi	a0,a0,-1330 # 80008910 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	222080e7          	jalr	546(ra) # 8000607e <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	a7670713          	addi	a4,a4,-1418 # 800088e0 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	2a8080e7          	jalr	680(ra) # 8000611e <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	2e4080e7          	jalr	740(ra) # 8000617e <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	99e7a783          	lw	a5,-1634(a5) # 80008840 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c5a080e7          	jalr	-934(ra) # 80001b06 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9807a223          	sw	zero,-1660(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	99e080e7          	jalr	-1634(ra) # 80002864 <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a0490913          	addi	s2,s2,-1532 # 800088e0 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	1e4080e7          	jalr	484(ra) # 800060ca <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	95678793          	addi	a5,a5,-1706 # 80008844 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	27e080e7          	jalr	638(ra) # 8000617e <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8aa080e7          	jalr	-1878(ra) # 800007ce <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	600080e7          	jalr	1536(ra) # 80000544 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	05893683          	ld	a3,88(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e2080e7          	jalr	1506(ra) # 80000544 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a52080e7          	jalr	-1454(ra) # 800009d2 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	770080e7          	jalr	1904(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a2c080e7          	jalr	-1492(ra) # 800009d2 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73c080e7          	jalr	1852(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	726080e7          	jalr	1830(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e2080e7          	jalr	-1566(ra) # 800009d2 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	6d28                	ld	a0,88(a0)
    80001012:	c509                	beqz	a0,8000101c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001020:	68a8                	ld	a0,80(s1)
    80001022:	c511                	beqz	a0,8000102e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001024:	64ac                	ld	a1,72(s1)
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	f8c080e7          	jalr	-116(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    8000102e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001032:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001036:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001042:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001046:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104e:	0004ac23          	sw	zero,24(s1)
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <allocproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	00008497          	auipc	s1,0x8
    8000106c:	ca848493          	addi	s1,s1,-856 # 80008d10 <proc>
    80001070:	0000d917          	auipc	s2,0xd
    80001074:	6a090913          	addi	s2,s2,1696 # 8000e710 <tickslock>
    acquire(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	050080e7          	jalr	80(ra) # 800060ca <acquire>
    if(p->state == UNUSED) {
    80001082:	4c9c                	lw	a5,24(s1)
    80001084:	cf81                	beqz	a5,8000109c <allocproc+0x40>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	0f6080e7          	jalr	246(ra) # 8000617e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	16848493          	addi	s1,s1,360
    80001094:	ff2492e3          	bne	s1,s2,80001078 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
    8000109a:	a889                	j	800010ec <allocproc+0x90>
  p->pid = allocpid();
    8000109c:	00000097          	auipc	ra,0x0
    800010a0:	e34080e7          	jalr	-460(ra) # 80000ed0 <allocpid>
    800010a4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a6:	4785                	li	a5,1
    800010a8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	06e080e7          	jalr	110(ra) # 80000118 <kalloc>
    800010b2:	892a                	mv	s2,a0
    800010b4:	eca8                	sd	a0,88(s1)
    800010b6:	c131                	beqz	a0,800010fa <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	e5c080e7          	jalr	-420(ra) # 80000f16 <proc_pagetable>
    800010c2:	892a                	mv	s2,a0
    800010c4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c6:	c531                	beqz	a0,80001112 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010c8:	07000613          	li	a2,112
    800010cc:	4581                	li	a1,0
    800010ce:	06048513          	addi	a0,s1,96
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	0a6080e7          	jalr	166(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010da:	00000797          	auipc	a5,0x0
    800010de:	db078793          	addi	a5,a5,-592 # 80000e8a <forkret>
    800010e2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e4:	60bc                	ld	a5,64(s1)
    800010e6:	6705                	lui	a4,0x1
    800010e8:	97ba                	add	a5,a5,a4
    800010ea:	f4bc                	sd	a5,104(s1)
}
    800010ec:	8526                	mv	a0,s1
    800010ee:	60e2                	ld	ra,24(sp)
    800010f0:	6442                	ld	s0,16(sp)
    800010f2:	64a2                	ld	s1,8(sp)
    800010f4:	6902                	ld	s2,0(sp)
    800010f6:	6105                	addi	sp,sp,32
    800010f8:	8082                	ret
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f08080e7          	jalr	-248(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	078080e7          	jalr	120(ra) # 8000617e <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	bff1                	j	800010ec <allocproc+0x90>
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	060080e7          	jalr	96(ra) # 8000617e <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	b7d1                	j	800010ec <allocproc+0x90>

000000008000112a <userinit>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
  p = allocproc();
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f28080e7          	jalr	-216(ra) # 8000105c <allocproc>
    8000113c:	84aa                	mv	s1,a0
  initproc = p;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	76a7b123          	sd	a0,1890(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001146:	03400613          	li	a2,52
    8000114a:	00007597          	auipc	a1,0x7
    8000114e:	70658593          	addi	a1,a1,1798 # 80008850 <initcode>
    80001152:	6928                	ld	a0,80(a0)
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	6a8080e7          	jalr	1704(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000115c:	6785                	lui	a5,0x1
    8000115e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001160:	6cb8                	ld	a4,88(s1)
    80001162:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	01458593          	addi	a1,a1,20 # 80008180 <etext+0x180>
    80001174:	15848513          	addi	a0,s1,344
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	14a080e7          	jalr	330(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	01050513          	addi	a0,a0,16 # 80008190 <etext+0x190>
    80001188:	00002097          	auipc	ra,0x2
    8000118c:	0fe080e7          	jalr	254(ra) # 80003286 <namei>
    80001190:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001194:	478d                	li	a5,3
    80001196:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001198:	8526                	mv	a0,s1
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	fe4080e7          	jalr	-28(ra) # 8000617e <release>
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <growproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	c98080e7          	jalr	-872(ra) # 80000e52 <myproc>
    800011c2:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c6:	01204c63          	bgtz	s2,800011de <growproc+0x32>
  } else if(n < 0){
    800011ca:	02094663          	bltz	s2,800011f6 <growproc+0x4a>
  p->sz = sz;
    800011ce:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011de:	4691                	li	a3,4
    800011e0:	00b90633          	add	a2,s2,a1
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d0080e7          	jalr	1744(ra) # 800008b6 <uvmalloc>
    800011ee:	85aa                	mv	a1,a0
    800011f0:	fd79                	bnez	a0,800011ce <growproc+0x22>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bff9                	j	800011d2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	00b90633          	add	a2,s2,a1
    800011fa:	6928                	ld	a0,80(a0)
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	672080e7          	jalr	1650(ra) # 8000086e <uvmdealloc>
    80001204:	85aa                	mv	a1,a0
    80001206:	b7e1                	j	800011ce <growproc+0x22>

0000000080001208 <fork>:
{
    80001208:	7139                	addi	sp,sp,-64
    8000120a:	fc06                	sd	ra,56(sp)
    8000120c:	f822                	sd	s0,48(sp)
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c38080e7          	jalr	-968(ra) # 80000e52 <myproc>
    80001222:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e38080e7          	jalr	-456(ra) # 8000105c <allocproc>
    8000122c:	10050c63          	beqz	a0,80001344 <fork+0x13c>
    80001230:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	048ab603          	ld	a2,72(s5)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	050ab503          	ld	a0,80(s5)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7ce080e7          	jalr	1998(ra) # 80000a0a <uvmcopy>
    80001244:	04054863          	bltz	a0,80001294 <fork+0x8c>
  np->sz = p->sz;
    80001248:	048ab783          	ld	a5,72(s5)
    8000124c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001250:	058ab683          	ld	a3,88(s5)
    80001254:	87b6                	mv	a5,a3
    80001256:	058a3703          	ld	a4,88(s4)
    8000125a:	12068693          	addi	a3,a3,288
    8000125e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001262:	6788                	ld	a0,8(a5)
    80001264:	6b8c                	ld	a1,16(a5)
    80001266:	6f90                	ld	a2,24(a5)
    80001268:	01073023          	sd	a6,0(a4)
    8000126c:	e708                	sd	a0,8(a4)
    8000126e:	eb0c                	sd	a1,16(a4)
    80001270:	ef10                	sd	a2,24(a4)
    80001272:	02078793          	addi	a5,a5,32
    80001276:	02070713          	addi	a4,a4,32
    8000127a:	fed792e3          	bne	a5,a3,8000125e <fork+0x56>
  np->trapframe->a0 = 0;
    8000127e:	058a3783          	ld	a5,88(s4)
    80001282:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001286:	0d0a8493          	addi	s1,s5,208
    8000128a:	0d0a0913          	addi	s2,s4,208
    8000128e:	150a8993          	addi	s3,s5,336
    80001292:	a00d                	j	800012b4 <fork+0xac>
    freeproc(np);
    80001294:	8552                	mv	a0,s4
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d6e080e7          	jalr	-658(ra) # 80001004 <freeproc>
    release(&np->lock);
    8000129e:	8552                	mv	a0,s4
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	ede080e7          	jalr	-290(ra) # 8000617e <release>
    return -1;
    800012a8:	597d                	li	s2,-1
    800012aa:	a059                	j	80001330 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ac:	04a1                	addi	s1,s1,8
    800012ae:	0921                	addi	s2,s2,8
    800012b0:	01348b63          	beq	s1,s3,800012c6 <fork+0xbe>
    if(p->ofile[i])
    800012b4:	6088                	ld	a0,0(s1)
    800012b6:	d97d                	beqz	a0,800012ac <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	664080e7          	jalr	1636(ra) # 8000391c <filedup>
    800012c0:	00a93023          	sd	a0,0(s2)
    800012c4:	b7e5                	j	800012ac <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c6:	150ab503          	ld	a0,336(s5)
    800012ca:	00001097          	auipc	ra,0x1
    800012ce:	7d8080e7          	jalr	2008(ra) # 80002aa2 <idup>
    800012d2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d6:	4641                	li	a2,16
    800012d8:	158a8593          	addi	a1,s5,344
    800012dc:	158a0513          	addi	a0,s4,344
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	fe2080e7          	jalr	-30(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012e8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	e90080e7          	jalr	-368(ra) # 8000617e <release>
  acquire(&wait_lock);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	60248493          	addi	s1,s1,1538 # 800088f8 <wait_lock>
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	dca080e7          	jalr	-566(ra) # 800060ca <acquire>
  np->parent = p;
    80001308:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	e70080e7          	jalr	-400(ra) # 8000617e <release>
  acquire(&np->lock);
    80001316:	8552                	mv	a0,s4
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	db2080e7          	jalr	-590(ra) # 800060ca <acquire>
  np->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001326:	8552                	mv	a0,s4
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	e56080e7          	jalr	-426(ra) # 8000617e <release>
}
    80001330:	854a                	mv	a0,s2
    80001332:	70e2                	ld	ra,56(sp)
    80001334:	7442                	ld	s0,48(sp)
    80001336:	74a2                	ld	s1,40(sp)
    80001338:	7902                	ld	s2,32(sp)
    8000133a:	69e2                	ld	s3,24(sp)
    8000133c:	6a42                	ld	s4,16(sp)
    8000133e:	6aa2                	ld	s5,8(sp)
    80001340:	6121                	addi	sp,sp,64
    80001342:	8082                	ret
    return -1;
    80001344:	597d                	li	s2,-1
    80001346:	b7ed                	j	80001330 <fork+0x128>

0000000080001348 <scheduler>:
{
    80001348:	7139                	addi	sp,sp,-64
    8000134a:	fc06                	sd	ra,56(sp)
    8000134c:	f822                	sd	s0,48(sp)
    8000134e:	f426                	sd	s1,40(sp)
    80001350:	f04a                	sd	s2,32(sp)
    80001352:	ec4e                	sd	s3,24(sp)
    80001354:	e852                	sd	s4,16(sp)
    80001356:	e456                	sd	s5,8(sp)
    80001358:	e05a                	sd	s6,0(sp)
    8000135a:	0080                	addi	s0,sp,64
    8000135c:	8792                	mv	a5,tp
  int id = r_tp();
    8000135e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001360:	00779a93          	slli	s5,a5,0x7
    80001364:	00007717          	auipc	a4,0x7
    80001368:	57c70713          	addi	a4,a4,1404 # 800088e0 <pid_lock>
    8000136c:	9756                	add	a4,a4,s5
    8000136e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5a670713          	addi	a4,a4,1446 # 80008918 <cpus+0x8>
    8000137a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137c:	498d                	li	s3,3
        p->state = RUNNING;
    8000137e:	4b11                	li	s6,4
        c->proc = p;
    80001380:	079e                	slli	a5,a5,0x7
    80001382:	00007a17          	auipc	s4,0x7
    80001386:	55ea0a13          	addi	s4,s4,1374 # 800088e0 <pid_lock>
    8000138a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138c:	0000d917          	auipc	s2,0xd
    80001390:	38490913          	addi	s2,s2,900 # 8000e710 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001394:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001398:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139c:	10079073          	csrw	sstatus,a5
    800013a0:	00008497          	auipc	s1,0x8
    800013a4:	97048493          	addi	s1,s1,-1680 # 80008d10 <proc>
    800013a8:	a811                	j	800013bc <scheduler+0x74>
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	dd2080e7          	jalr	-558(ra) # 8000617e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b4:	16848493          	addi	s1,s1,360
    800013b8:	fd248ee3          	beq	s1,s2,80001394 <scheduler+0x4c>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	d0c080e7          	jalr	-756(ra) # 800060ca <acquire>
      if(p->state == RUNNABLE) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <scheduler+0x62>
        p->state = RUNNING;
    800013cc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d4:	06048593          	addi	a1,s1,96
    800013d8:	8556                	mv	a0,s5
    800013da:	00000097          	auipc	ra,0x0
    800013de:	682080e7          	jalr	1666(ra) # 80001a5c <swtch>
        c->proc = 0;
    800013e2:	020a3823          	sd	zero,48(s4)
    800013e6:	b7d1                	j	800013aa <scheduler+0x62>

00000000800013e8 <sched>:
{
    800013e8:	7179                	addi	sp,sp,-48
    800013ea:	f406                	sd	ra,40(sp)
    800013ec:	f022                	sd	s0,32(sp)
    800013ee:	ec26                	sd	s1,24(sp)
    800013f0:	e84a                	sd	s2,16(sp)
    800013f2:	e44e                	sd	s3,8(sp)
    800013f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	a5c080e7          	jalr	-1444(ra) # 80000e52 <myproc>
    800013fe:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001400:	00005097          	auipc	ra,0x5
    80001404:	c50080e7          	jalr	-944(ra) # 80006050 <holding>
    80001408:	c93d                	beqz	a0,8000147e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140c:	2781                	sext.w	a5,a5
    8000140e:	079e                	slli	a5,a5,0x7
    80001410:	00007717          	auipc	a4,0x7
    80001414:	4d070713          	addi	a4,a4,1232 # 800088e0 <pid_lock>
    80001418:	97ba                	add	a5,a5,a4
    8000141a:	0a87a703          	lw	a4,168(a5)
    8000141e:	4785                	li	a5,1
    80001420:	06f71763          	bne	a4,a5,8000148e <sched+0xa6>
  if(p->state == RUNNING)
    80001424:	4c98                	lw	a4,24(s1)
    80001426:	4791                	li	a5,4
    80001428:	06f70b63          	beq	a4,a5,8000149e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001430:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001432:	efb5                	bnez	a5,800014ae <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001434:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001436:	00007917          	auipc	s2,0x7
    8000143a:	4aa90913          	addi	s2,s2,1194 # 800088e0 <pid_lock>
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	97ca                	add	a5,a5,s2
    80001444:	0ac7a983          	lw	s3,172(a5)
    80001448:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	00007597          	auipc	a1,0x7
    80001452:	4ca58593          	addi	a1,a1,1226 # 80008918 <cpus+0x8>
    80001456:	95be                	add	a1,a1,a5
    80001458:	06048513          	addi	a0,s1,96
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	600080e7          	jalr	1536(ra) # 80001a5c <swtch>
    80001464:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	97ca                	add	a5,a5,s2
    8000146c:	0b37a623          	sw	s3,172(a5)
}
    80001470:	70a2                	ld	ra,40(sp)
    80001472:	7402                	ld	s0,32(sp)
    80001474:	64e2                	ld	s1,24(sp)
    80001476:	6942                	ld	s2,16(sp)
    80001478:	69a2                	ld	s3,8(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret
    panic("sched p->lock");
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	d1a50513          	addi	a0,a0,-742 # 80008198 <etext+0x198>
    80001486:	00004097          	auipc	ra,0x4
    8000148a:	708080e7          	jalr	1800(ra) # 80005b8e <panic>
    panic("sched locks");
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	d1a50513          	addi	a0,a0,-742 # 800081a8 <etext+0x1a8>
    80001496:	00004097          	auipc	ra,0x4
    8000149a:	6f8080e7          	jalr	1784(ra) # 80005b8e <panic>
    panic("sched running");
    8000149e:	00007517          	auipc	a0,0x7
    800014a2:	d1a50513          	addi	a0,a0,-742 # 800081b8 <etext+0x1b8>
    800014a6:	00004097          	auipc	ra,0x4
    800014aa:	6e8080e7          	jalr	1768(ra) # 80005b8e <panic>
    panic("sched interruptible");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	d1a50513          	addi	a0,a0,-742 # 800081c8 <etext+0x1c8>
    800014b6:	00004097          	auipc	ra,0x4
    800014ba:	6d8080e7          	jalr	1752(ra) # 80005b8e <panic>

00000000800014be <yield>:
{
    800014be:	1101                	addi	sp,sp,-32
    800014c0:	ec06                	sd	ra,24(sp)
    800014c2:	e822                	sd	s0,16(sp)
    800014c4:	e426                	sd	s1,8(sp)
    800014c6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	98a080e7          	jalr	-1654(ra) # 80000e52 <myproc>
    800014d0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	bf8080e7          	jalr	-1032(ra) # 800060ca <acquire>
  p->state = RUNNABLE;
    800014da:	478d                	li	a5,3
    800014dc:	cc9c                	sw	a5,24(s1)
  sched();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	f0a080e7          	jalr	-246(ra) # 800013e8 <sched>
  release(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	c96080e7          	jalr	-874(ra) # 8000617e <release>
}
    800014f0:	60e2                	ld	ra,24(sp)
    800014f2:	6442                	ld	s0,16(sp)
    800014f4:	64a2                	ld	s1,8(sp)
    800014f6:	6105                	addi	sp,sp,32
    800014f8:	8082                	ret

00000000800014fa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fa:	7179                	addi	sp,sp,-48
    800014fc:	f406                	sd	ra,40(sp)
    800014fe:	f022                	sd	s0,32(sp)
    80001500:	ec26                	sd	s1,24(sp)
    80001502:	e84a                	sd	s2,16(sp)
    80001504:	e44e                	sd	s3,8(sp)
    80001506:	1800                	addi	s0,sp,48
    80001508:	89aa                	mv	s3,a0
    8000150a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	946080e7          	jalr	-1722(ra) # 80000e52 <myproc>
    80001514:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	bb4080e7          	jalr	-1100(ra) # 800060ca <acquire>
  release(lk);
    8000151e:	854a                	mv	a0,s2
    80001520:	00005097          	auipc	ra,0x5
    80001524:	c5e080e7          	jalr	-930(ra) # 8000617e <release>

  // Go to sleep.
  p->chan = chan;
    80001528:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152c:	4789                	li	a5,2
    8000152e:	cc9c                	sw	a5,24(s1)

  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	eb8080e7          	jalr	-328(ra) # 800013e8 <sched>

  // Tidy up.
  p->chan = 0;
    80001538:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	c40080e7          	jalr	-960(ra) # 8000617e <release>
  acquire(lk);
    80001546:	854a                	mv	a0,s2
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	b82080e7          	jalr	-1150(ra) # 800060ca <acquire>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6145                	addi	sp,sp,48
    8000155c:	8082                	ret

000000008000155e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000155e:	7139                	addi	sp,sp,-64
    80001560:	fc06                	sd	ra,56(sp)
    80001562:	f822                	sd	s0,48(sp)
    80001564:	f426                	sd	s1,40(sp)
    80001566:	f04a                	sd	s2,32(sp)
    80001568:	ec4e                	sd	s3,24(sp)
    8000156a:	e852                	sd	s4,16(sp)
    8000156c:	e456                	sd	s5,8(sp)
    8000156e:	0080                	addi	s0,sp,64
    80001570:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	00007497          	auipc	s1,0x7
    80001576:	79e48493          	addi	s1,s1,1950 # 80008d10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000157a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	0000d917          	auipc	s2,0xd
    80001582:	19290913          	addi	s2,s2,402 # 8000e710 <tickslock>
    80001586:	a811                	j	8000159a <wakeup+0x3c>
      }
      release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	bf4080e7          	jalr	-1036(ra) # 8000617e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001592:	16848493          	addi	s1,s1,360
    80001596:	03248663          	beq	s1,s2,800015c2 <wakeup+0x64>
    if(p != myproc()){
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	8b8080e7          	jalr	-1864(ra) # 80000e52 <myproc>
    800015a2:	fea488e3          	beq	s1,a0,80001592 <wakeup+0x34>
      acquire(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	b22080e7          	jalr	-1246(ra) # 800060ca <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b0:	4c9c                	lw	a5,24(s1)
    800015b2:	fd379be3          	bne	a5,s3,80001588 <wakeup+0x2a>
    800015b6:	709c                	ld	a5,32(s1)
    800015b8:	fd4798e3          	bne	a5,s4,80001588 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015bc:	0154ac23          	sw	s5,24(s1)
    800015c0:	b7e1                	j	80001588 <wakeup+0x2a>
    }
  }
}
    800015c2:	70e2                	ld	ra,56(sp)
    800015c4:	7442                	ld	s0,48(sp)
    800015c6:	74a2                	ld	s1,40(sp)
    800015c8:	7902                	ld	s2,32(sp)
    800015ca:	69e2                	ld	s3,24(sp)
    800015cc:	6a42                	ld	s4,16(sp)
    800015ce:	6aa2                	ld	s5,8(sp)
    800015d0:	6121                	addi	sp,sp,64
    800015d2:	8082                	ret

00000000800015d4 <reparent>:
{
    800015d4:	7179                	addi	sp,sp,-48
    800015d6:	f406                	sd	ra,40(sp)
    800015d8:	f022                	sd	s0,32(sp)
    800015da:	ec26                	sd	s1,24(sp)
    800015dc:	e84a                	sd	s2,16(sp)
    800015de:	e44e                	sd	s3,8(sp)
    800015e0:	e052                	sd	s4,0(sp)
    800015e2:	1800                	addi	s0,sp,48
    800015e4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e6:	00007497          	auipc	s1,0x7
    800015ea:	72a48493          	addi	s1,s1,1834 # 80008d10 <proc>
      pp->parent = initproc;
    800015ee:	00007a17          	auipc	s4,0x7
    800015f2:	2b2a0a13          	addi	s4,s4,690 # 800088a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f6:	0000d997          	auipc	s3,0xd
    800015fa:	11a98993          	addi	s3,s3,282 # 8000e710 <tickslock>
    800015fe:	a029                	j	80001608 <reparent+0x34>
    80001600:	16848493          	addi	s1,s1,360
    80001604:	01348d63          	beq	s1,s3,8000161e <reparent+0x4a>
    if(pp->parent == p){
    80001608:	7c9c                	ld	a5,56(s1)
    8000160a:	ff279be3          	bne	a5,s2,80001600 <reparent+0x2c>
      pp->parent = initproc;
    8000160e:	000a3503          	ld	a0,0(s4)
    80001612:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001614:	00000097          	auipc	ra,0x0
    80001618:	f4a080e7          	jalr	-182(ra) # 8000155e <wakeup>
    8000161c:	b7d5                	j	80001600 <reparent+0x2c>
}
    8000161e:	70a2                	ld	ra,40(sp)
    80001620:	7402                	ld	s0,32(sp)
    80001622:	64e2                	ld	s1,24(sp)
    80001624:	6942                	ld	s2,16(sp)
    80001626:	69a2                	ld	s3,8(sp)
    80001628:	6a02                	ld	s4,0(sp)
    8000162a:	6145                	addi	sp,sp,48
    8000162c:	8082                	ret

000000008000162e <exit>:
{
    8000162e:	7179                	addi	sp,sp,-48
    80001630:	f406                	sd	ra,40(sp)
    80001632:	f022                	sd	s0,32(sp)
    80001634:	ec26                	sd	s1,24(sp)
    80001636:	e84a                	sd	s2,16(sp)
    80001638:	e44e                	sd	s3,8(sp)
    8000163a:	e052                	sd	s4,0(sp)
    8000163c:	1800                	addi	s0,sp,48
    8000163e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	812080e7          	jalr	-2030(ra) # 80000e52 <myproc>
    80001648:	89aa                	mv	s3,a0
  if(p == initproc)
    8000164a:	00007797          	auipc	a5,0x7
    8000164e:	2567b783          	ld	a5,598(a5) # 800088a0 <initproc>
    80001652:	0d050493          	addi	s1,a0,208
    80001656:	15050913          	addi	s2,a0,336
    8000165a:	02a79363          	bne	a5,a0,80001680 <exit+0x52>
    panic("init exiting");
    8000165e:	00007517          	auipc	a0,0x7
    80001662:	b8250513          	addi	a0,a0,-1150 # 800081e0 <etext+0x1e0>
    80001666:	00004097          	auipc	ra,0x4
    8000166a:	528080e7          	jalr	1320(ra) # 80005b8e <panic>
      fileclose(f);
    8000166e:	00002097          	auipc	ra,0x2
    80001672:	300080e7          	jalr	768(ra) # 8000396e <fileclose>
      p->ofile[fd] = 0;
    80001676:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000167a:	04a1                	addi	s1,s1,8
    8000167c:	01248563          	beq	s1,s2,80001686 <exit+0x58>
    if(p->ofile[fd]){
    80001680:	6088                	ld	a0,0(s1)
    80001682:	f575                	bnez	a0,8000166e <exit+0x40>
    80001684:	bfdd                	j	8000167a <exit+0x4c>
  begin_op();
    80001686:	00002097          	auipc	ra,0x2
    8000168a:	e1c080e7          	jalr	-484(ra) # 800034a2 <begin_op>
  iput(p->cwd);
    8000168e:	1509b503          	ld	a0,336(s3)
    80001692:	00001097          	auipc	ra,0x1
    80001696:	608080e7          	jalr	1544(ra) # 80002c9a <iput>
  end_op();
    8000169a:	00002097          	auipc	ra,0x2
    8000169e:	e88080e7          	jalr	-376(ra) # 80003522 <end_op>
  p->cwd = 0;
    800016a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a6:	00007497          	auipc	s1,0x7
    800016aa:	25248493          	addi	s1,s1,594 # 800088f8 <wait_lock>
    800016ae:	8526                	mv	a0,s1
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	a1a080e7          	jalr	-1510(ra) # 800060ca <acquire>
  reparent(p);
    800016b8:	854e                	mv	a0,s3
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	f1a080e7          	jalr	-230(ra) # 800015d4 <reparent>
  wakeup(p->parent);
    800016c2:	0389b503          	ld	a0,56(s3)
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	e98080e7          	jalr	-360(ra) # 8000155e <wakeup>
  acquire(&p->lock);
    800016ce:	854e                	mv	a0,s3
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	9fa080e7          	jalr	-1542(ra) # 800060ca <acquire>
  p->xstate = status;
    800016d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016dc:	4795                	li	a5,5
    800016de:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	a9a080e7          	jalr	-1382(ra) # 8000617e <release>
  sched();
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	cfc080e7          	jalr	-772(ra) # 800013e8 <sched>
  panic("zombie exit");
    800016f4:	00007517          	auipc	a0,0x7
    800016f8:	afc50513          	addi	a0,a0,-1284 # 800081f0 <etext+0x1f0>
    800016fc:	00004097          	auipc	ra,0x4
    80001700:	492080e7          	jalr	1170(ra) # 80005b8e <panic>

0000000080001704 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001704:	7179                	addi	sp,sp,-48
    80001706:	f406                	sd	ra,40(sp)
    80001708:	f022                	sd	s0,32(sp)
    8000170a:	ec26                	sd	s1,24(sp)
    8000170c:	e84a                	sd	s2,16(sp)
    8000170e:	e44e                	sd	s3,8(sp)
    80001710:	1800                	addi	s0,sp,48
    80001712:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001714:	00007497          	auipc	s1,0x7
    80001718:	5fc48493          	addi	s1,s1,1532 # 80008d10 <proc>
    8000171c:	0000d997          	auipc	s3,0xd
    80001720:	ff498993          	addi	s3,s3,-12 # 8000e710 <tickslock>
    acquire(&p->lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	9a4080e7          	jalr	-1628(ra) # 800060ca <acquire>
    if(p->pid == pid){
    8000172e:	589c                	lw	a5,48(s1)
    80001730:	01278d63          	beq	a5,s2,8000174a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001734:	8526                	mv	a0,s1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	a48080e7          	jalr	-1464(ra) # 8000617e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000173e:	16848493          	addi	s1,s1,360
    80001742:	ff3491e3          	bne	s1,s3,80001724 <kill+0x20>
  }
  return -1;
    80001746:	557d                	li	a0,-1
    80001748:	a829                	j	80001762 <kill+0x5e>
      p->killed = 1;
    8000174a:	4785                	li	a5,1
    8000174c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000174e:	4c98                	lw	a4,24(s1)
    80001750:	4789                	li	a5,2
    80001752:	00f70f63          	beq	a4,a5,80001770 <kill+0x6c>
      release(&p->lock);
    80001756:	8526                	mv	a0,s1
    80001758:	00005097          	auipc	ra,0x5
    8000175c:	a26080e7          	jalr	-1498(ra) # 8000617e <release>
      return 0;
    80001760:	4501                	li	a0,0
}
    80001762:	70a2                	ld	ra,40(sp)
    80001764:	7402                	ld	s0,32(sp)
    80001766:	64e2                	ld	s1,24(sp)
    80001768:	6942                	ld	s2,16(sp)
    8000176a:	69a2                	ld	s3,8(sp)
    8000176c:	6145                	addi	sp,sp,48
    8000176e:	8082                	ret
        p->state = RUNNABLE;
    80001770:	478d                	li	a5,3
    80001772:	cc9c                	sw	a5,24(s1)
    80001774:	b7cd                	j	80001756 <kill+0x52>

0000000080001776 <setkilled>:

void
setkilled(struct proc *p)
{
    80001776:	1101                	addi	sp,sp,-32
    80001778:	ec06                	sd	ra,24(sp)
    8000177a:	e822                	sd	s0,16(sp)
    8000177c:	e426                	sd	s1,8(sp)
    8000177e:	1000                	addi	s0,sp,32
    80001780:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001782:	00005097          	auipc	ra,0x5
    80001786:	948080e7          	jalr	-1720(ra) # 800060ca <acquire>
  p->killed = 1;
    8000178a:	4785                	li	a5,1
    8000178c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	9ee080e7          	jalr	-1554(ra) # 8000617e <release>
}
    80001798:	60e2                	ld	ra,24(sp)
    8000179a:	6442                	ld	s0,16(sp)
    8000179c:	64a2                	ld	s1,8(sp)
    8000179e:	6105                	addi	sp,sp,32
    800017a0:	8082                	ret

00000000800017a2 <killed>:

int
killed(struct proc *p)
{
    800017a2:	1101                	addi	sp,sp,-32
    800017a4:	ec06                	sd	ra,24(sp)
    800017a6:	e822                	sd	s0,16(sp)
    800017a8:	e426                	sd	s1,8(sp)
    800017aa:	e04a                	sd	s2,0(sp)
    800017ac:	1000                	addi	s0,sp,32
    800017ae:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	91a080e7          	jalr	-1766(ra) # 800060ca <acquire>
  k = p->killed;
    800017b8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	9c0080e7          	jalr	-1600(ra) # 8000617e <release>
  return k;
}
    800017c6:	854a                	mv	a0,s2
    800017c8:	60e2                	ld	ra,24(sp)
    800017ca:	6442                	ld	s0,16(sp)
    800017cc:	64a2                	ld	s1,8(sp)
    800017ce:	6902                	ld	s2,0(sp)
    800017d0:	6105                	addi	sp,sp,32
    800017d2:	8082                	ret

00000000800017d4 <wait>:
{
    800017d4:	715d                	addi	sp,sp,-80
    800017d6:	e486                	sd	ra,72(sp)
    800017d8:	e0a2                	sd	s0,64(sp)
    800017da:	fc26                	sd	s1,56(sp)
    800017dc:	f84a                	sd	s2,48(sp)
    800017de:	f44e                	sd	s3,40(sp)
    800017e0:	f052                	sd	s4,32(sp)
    800017e2:	ec56                	sd	s5,24(sp)
    800017e4:	e85a                	sd	s6,16(sp)
    800017e6:	e45e                	sd	s7,8(sp)
    800017e8:	e062                	sd	s8,0(sp)
    800017ea:	0880                	addi	s0,sp,80
    800017ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017ee:	fffff097          	auipc	ra,0xfffff
    800017f2:	664080e7          	jalr	1636(ra) # 80000e52 <myproc>
    800017f6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f8:	00007517          	auipc	a0,0x7
    800017fc:	10050513          	addi	a0,a0,256 # 800088f8 <wait_lock>
    80001800:	00005097          	auipc	ra,0x5
    80001804:	8ca080e7          	jalr	-1846(ra) # 800060ca <acquire>
    havekids = 0;
    80001808:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000180a:	4a15                	li	s4,5
        havekids = 1;
    8000180c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180e:	0000d997          	auipc	s3,0xd
    80001812:	f0298993          	addi	s3,s3,-254 # 8000e710 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001816:	00007c17          	auipc	s8,0x7
    8000181a:	0e2c0c13          	addi	s8,s8,226 # 800088f8 <wait_lock>
    havekids = 0;
    8000181e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001820:	00007497          	auipc	s1,0x7
    80001824:	4f048493          	addi	s1,s1,1264 # 80008d10 <proc>
    80001828:	a0bd                	j	80001896 <wait+0xc2>
          pid = pp->pid;
    8000182a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000182e:	000b0e63          	beqz	s6,8000184a <wait+0x76>
    80001832:	4691                	li	a3,4
    80001834:	02c48613          	addi	a2,s1,44
    80001838:	85da                	mv	a1,s6
    8000183a:	05093503          	ld	a0,80(s2)
    8000183e:	fffff097          	auipc	ra,0xfffff
    80001842:	2d0080e7          	jalr	720(ra) # 80000b0e <copyout>
    80001846:	02054563          	bltz	a0,80001870 <wait+0x9c>
          freeproc(pp);
    8000184a:	8526                	mv	a0,s1
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	7b8080e7          	jalr	1976(ra) # 80001004 <freeproc>
          release(&pp->lock);
    80001854:	8526                	mv	a0,s1
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	928080e7          	jalr	-1752(ra) # 8000617e <release>
          release(&wait_lock);
    8000185e:	00007517          	auipc	a0,0x7
    80001862:	09a50513          	addi	a0,a0,154 # 800088f8 <wait_lock>
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	918080e7          	jalr	-1768(ra) # 8000617e <release>
          return pid;
    8000186e:	a0b5                	j	800018da <wait+0x106>
            release(&pp->lock);
    80001870:	8526                	mv	a0,s1
    80001872:	00005097          	auipc	ra,0x5
    80001876:	90c080e7          	jalr	-1780(ra) # 8000617e <release>
            release(&wait_lock);
    8000187a:	00007517          	auipc	a0,0x7
    8000187e:	07e50513          	addi	a0,a0,126 # 800088f8 <wait_lock>
    80001882:	00005097          	auipc	ra,0x5
    80001886:	8fc080e7          	jalr	-1796(ra) # 8000617e <release>
            return -1;
    8000188a:	59fd                	li	s3,-1
    8000188c:	a0b9                	j	800018da <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000188e:	16848493          	addi	s1,s1,360
    80001892:	03348463          	beq	s1,s3,800018ba <wait+0xe6>
      if(pp->parent == p){
    80001896:	7c9c                	ld	a5,56(s1)
    80001898:	ff279be3          	bne	a5,s2,8000188e <wait+0xba>
        acquire(&pp->lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	82c080e7          	jalr	-2004(ra) # 800060ca <acquire>
        if(pp->state == ZOMBIE){
    800018a6:	4c9c                	lw	a5,24(s1)
    800018a8:	f94781e3          	beq	a5,s4,8000182a <wait+0x56>
        release(&pp->lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	8d0080e7          	jalr	-1840(ra) # 8000617e <release>
        havekids = 1;
    800018b6:	8756                	mv	a4,s5
    800018b8:	bfd9                	j	8000188e <wait+0xba>
    if(!havekids || killed(p)){
    800018ba:	c719                	beqz	a4,800018c8 <wait+0xf4>
    800018bc:	854a                	mv	a0,s2
    800018be:	00000097          	auipc	ra,0x0
    800018c2:	ee4080e7          	jalr	-284(ra) # 800017a2 <killed>
    800018c6:	c51d                	beqz	a0,800018f4 <wait+0x120>
      release(&wait_lock);
    800018c8:	00007517          	auipc	a0,0x7
    800018cc:	03050513          	addi	a0,a0,48 # 800088f8 <wait_lock>
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	8ae080e7          	jalr	-1874(ra) # 8000617e <release>
      return -1;
    800018d8:	59fd                	li	s3,-1
}
    800018da:	854e                	mv	a0,s3
    800018dc:	60a6                	ld	ra,72(sp)
    800018de:	6406                	ld	s0,64(sp)
    800018e0:	74e2                	ld	s1,56(sp)
    800018e2:	7942                	ld	s2,48(sp)
    800018e4:	79a2                	ld	s3,40(sp)
    800018e6:	7a02                	ld	s4,32(sp)
    800018e8:	6ae2                	ld	s5,24(sp)
    800018ea:	6b42                	ld	s6,16(sp)
    800018ec:	6ba2                	ld	s7,8(sp)
    800018ee:	6c02                	ld	s8,0(sp)
    800018f0:	6161                	addi	sp,sp,80
    800018f2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018f4:	85e2                	mv	a1,s8
    800018f6:	854a                	mv	a0,s2
    800018f8:	00000097          	auipc	ra,0x0
    800018fc:	c02080e7          	jalr	-1022(ra) # 800014fa <sleep>
    havekids = 0;
    80001900:	bf39                	j	8000181e <wait+0x4a>

0000000080001902 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	84aa                	mv	s1,a0
    80001914:	892e                	mv	s2,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	538080e7          	jalr	1336(ra) # 80000e52 <myproc>
  if(user_dst){
    80001922:	c08d                	beqz	s1,80001944 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	1e2080e7          	jalr	482(ra) # 80000b0e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret
    memmove((char *)dst, src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	888080e7          	jalr	-1912(ra) # 800001d4 <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyout+0x32>

0000000080001958 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
    8000196a:	84ae                	mv	s1,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	4e2080e7          	jalr	1250(ra) # 80000e52 <myproc>
  if(user_src){
    80001978:	c08d                	beqz	s1,8000199a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	218080e7          	jalr	536(ra) # 80000b9a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	832080e7          	jalr	-1998(ra) # 800001d4 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyin+0x32>

00000000800019ae <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ae:	715d                	addi	sp,sp,-80
    800019b0:	e486                	sd	ra,72(sp)
    800019b2:	e0a2                	sd	s0,64(sp)
    800019b4:	fc26                	sd	s1,56(sp)
    800019b6:	f84a                	sd	s2,48(sp)
    800019b8:	f44e                	sd	s3,40(sp)
    800019ba:	f052                	sd	s4,32(sp)
    800019bc:	ec56                	sd	s5,24(sp)
    800019be:	e85a                	sd	s6,16(sp)
    800019c0:	e45e                	sd	s7,8(sp)
    800019c2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c4:	00006517          	auipc	a0,0x6
    800019c8:	68450513          	addi	a0,a0,1668 # 80008048 <etext+0x48>
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	20c080e7          	jalr	524(ra) # 80005bd8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	00007497          	auipc	s1,0x7
    800019d8:	49448493          	addi	s1,s1,1172 # 80008e68 <proc+0x158>
    800019dc:	0000d917          	auipc	s2,0xd
    800019e0:	e8c90913          	addi	s2,s2,-372 # 8000e868 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e6:	00007997          	auipc	s3,0x7
    800019ea:	81a98993          	addi	s3,s3,-2022 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	00007a97          	auipc	s5,0x7
    800019f2:	81aa8a93          	addi	s5,s5,-2022 # 80008208 <etext+0x208>
    printf("\n");
    800019f6:	00006a17          	auipc	s4,0x6
    800019fa:	652a0a13          	addi	s4,s4,1618 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fe:	00007b97          	auipc	s7,0x7
    80001a02:	84ab8b93          	addi	s7,s7,-1974 # 80008248 <states.0>
    80001a06:	a00d                	j	80001a28 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a08:	ed86a583          	lw	a1,-296(a3)
    80001a0c:	8556                	mv	a0,s5
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	1ca080e7          	jalr	458(ra) # 80005bd8 <printf>
    printf("\n");
    80001a16:	8552                	mv	a0,s4
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	1c0080e7          	jalr	448(ra) # 80005bd8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	16848493          	addi	s1,s1,360
    80001a24:	03248163          	beq	s1,s2,80001a46 <procdump+0x98>
    if(p->state == UNUSED)
    80001a28:	86a6                	mv	a3,s1
    80001a2a:	ec04a783          	lw	a5,-320(s1)
    80001a2e:	dbed                	beqz	a5,80001a20 <procdump+0x72>
      state = "???";
    80001a30:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a32:	fcfb6be3          	bltu	s6,a5,80001a08 <procdump+0x5a>
    80001a36:	1782                	slli	a5,a5,0x20
    80001a38:	9381                	srli	a5,a5,0x20
    80001a3a:	078e                	slli	a5,a5,0x3
    80001a3c:	97de                	add	a5,a5,s7
    80001a3e:	6390                	ld	a2,0(a5)
    80001a40:	f661                	bnez	a2,80001a08 <procdump+0x5a>
      state = "???";
    80001a42:	864e                	mv	a2,s3
    80001a44:	b7d1                	j	80001a08 <procdump+0x5a>
  }
}
    80001a46:	60a6                	ld	ra,72(sp)
    80001a48:	6406                	ld	s0,64(sp)
    80001a4a:	74e2                	ld	s1,56(sp)
    80001a4c:	7942                	ld	s2,48(sp)
    80001a4e:	79a2                	ld	s3,40(sp)
    80001a50:	7a02                	ld	s4,32(sp)
    80001a52:	6ae2                	ld	s5,24(sp)
    80001a54:	6b42                	ld	s6,16(sp)
    80001a56:	6ba2                	ld	s7,8(sp)
    80001a58:	6161                	addi	sp,sp,80
    80001a5a:	8082                	ret

0000000080001a5c <swtch>:
    80001a5c:	00153023          	sd	ra,0(a0)
    80001a60:	00253423          	sd	sp,8(a0)
    80001a64:	e900                	sd	s0,16(a0)
    80001a66:	ed04                	sd	s1,24(a0)
    80001a68:	03253023          	sd	s2,32(a0)
    80001a6c:	03353423          	sd	s3,40(a0)
    80001a70:	03453823          	sd	s4,48(a0)
    80001a74:	03553c23          	sd	s5,56(a0)
    80001a78:	05653023          	sd	s6,64(a0)
    80001a7c:	05753423          	sd	s7,72(a0)
    80001a80:	05853823          	sd	s8,80(a0)
    80001a84:	05953c23          	sd	s9,88(a0)
    80001a88:	07a53023          	sd	s10,96(a0)
    80001a8c:	07b53423          	sd	s11,104(a0)
    80001a90:	0005b083          	ld	ra,0(a1)
    80001a94:	0085b103          	ld	sp,8(a1)
    80001a98:	6980                	ld	s0,16(a1)
    80001a9a:	6d84                	ld	s1,24(a1)
    80001a9c:	0205b903          	ld	s2,32(a1)
    80001aa0:	0285b983          	ld	s3,40(a1)
    80001aa4:	0305ba03          	ld	s4,48(a1)
    80001aa8:	0385ba83          	ld	s5,56(a1)
    80001aac:	0405bb03          	ld	s6,64(a1)
    80001ab0:	0485bb83          	ld	s7,72(a1)
    80001ab4:	0505bc03          	ld	s8,80(a1)
    80001ab8:	0585bc83          	ld	s9,88(a1)
    80001abc:	0605bd03          	ld	s10,96(a1)
    80001ac0:	0685bd83          	ld	s11,104(a1)
    80001ac4:	8082                	ret

0000000080001ac6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac6:	1141                	addi	sp,sp,-16
    80001ac8:	e406                	sd	ra,8(sp)
    80001aca:	e022                	sd	s0,0(sp)
    80001acc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ace:	00006597          	auipc	a1,0x6
    80001ad2:	7aa58593          	addi	a1,a1,1962 # 80008278 <states.0+0x30>
    80001ad6:	0000d517          	auipc	a0,0xd
    80001ada:	c3a50513          	addi	a0,a0,-966 # 8000e710 <tickslock>
    80001ade:	00004097          	auipc	ra,0x4
    80001ae2:	55c080e7          	jalr	1372(ra) # 8000603a <initlock>
}
    80001ae6:	60a2                	ld	ra,8(sp)
    80001ae8:	6402                	ld	s0,0(sp)
    80001aea:	0141                	addi	sp,sp,16
    80001aec:	8082                	ret

0000000080001aee <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aee:	1141                	addi	sp,sp,-16
    80001af0:	e422                	sd	s0,8(sp)
    80001af2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af4:	00003797          	auipc	a5,0x3
    80001af8:	4cc78793          	addi	a5,a5,1228 # 80004fc0 <kernelvec>
    80001afc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b00:	6422                	ld	s0,8(sp)
    80001b02:	0141                	addi	sp,sp,16
    80001b04:	8082                	ret

0000000080001b06 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b06:	1141                	addi	sp,sp,-16
    80001b08:	e406                	sd	ra,8(sp)
    80001b0a:	e022                	sd	s0,0(sp)
    80001b0c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b0e:	fffff097          	auipc	ra,0xfffff
    80001b12:	344080e7          	jalr	836(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b16:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b20:	00005617          	auipc	a2,0x5
    80001b24:	4e060613          	addi	a2,a2,1248 # 80007000 <_trampoline>
    80001b28:	00005697          	auipc	a3,0x5
    80001b2c:	4d868693          	addi	a3,a3,1240 # 80007000 <_trampoline>
    80001b30:	8e91                	sub	a3,a3,a2
    80001b32:	040007b7          	lui	a5,0x4000
    80001b36:	17fd                	addi	a5,a5,-1
    80001b38:	07b2                	slli	a5,a5,0xc
    80001b3a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3c:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b40:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b42:	180026f3          	csrr	a3,satp
    80001b46:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b48:	6d38                	ld	a4,88(a0)
    80001b4a:	6134                	ld	a3,64(a0)
    80001b4c:	6585                	lui	a1,0x1
    80001b4e:	96ae                	add	a3,a3,a1
    80001b50:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b52:	6d38                	ld	a4,88(a0)
    80001b54:	00000697          	auipc	a3,0x0
    80001b58:	13068693          	addi	a3,a3,304 # 80001c84 <usertrap>
    80001b5c:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b5e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b60:	8692                	mv	a3,tp
    80001b62:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b64:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b68:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b6c:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b70:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b74:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b76:	6f18                	ld	a4,24(a4)
    80001b78:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7c:	6928                	ld	a0,80(a0)
    80001b7e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b80:	00005717          	auipc	a4,0x5
    80001b84:	51c70713          	addi	a4,a4,1308 # 8000709c <userret>
    80001b88:	8f11                	sub	a4,a4,a2
    80001b8a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b8c:	577d                	li	a4,-1
    80001b8e:	177e                	slli	a4,a4,0x3f
    80001b90:	8d59                	or	a0,a0,a4
    80001b92:	9782                	jalr	a5
}
    80001b94:	60a2                	ld	ra,8(sp)
    80001b96:	6402                	ld	s0,0(sp)
    80001b98:	0141                	addi	sp,sp,16
    80001b9a:	8082                	ret

0000000080001b9c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9c:	1101                	addi	sp,sp,-32
    80001b9e:	ec06                	sd	ra,24(sp)
    80001ba0:	e822                	sd	s0,16(sp)
    80001ba2:	e426                	sd	s1,8(sp)
    80001ba4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba6:	0000d497          	auipc	s1,0xd
    80001baa:	b6a48493          	addi	s1,s1,-1174 # 8000e710 <tickslock>
    80001bae:	8526                	mv	a0,s1
    80001bb0:	00004097          	auipc	ra,0x4
    80001bb4:	51a080e7          	jalr	1306(ra) # 800060ca <acquire>
  ticks++;
    80001bb8:	00007517          	auipc	a0,0x7
    80001bbc:	cf050513          	addi	a0,a0,-784 # 800088a8 <ticks>
    80001bc0:	411c                	lw	a5,0(a0)
    80001bc2:	2785                	addiw	a5,a5,1
    80001bc4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc6:	00000097          	auipc	ra,0x0
    80001bca:	998080e7          	jalr	-1640(ra) # 8000155e <wakeup>
  release(&tickslock);
    80001bce:	8526                	mv	a0,s1
    80001bd0:	00004097          	auipc	ra,0x4
    80001bd4:	5ae080e7          	jalr	1454(ra) # 8000617e <release>
}
    80001bd8:	60e2                	ld	ra,24(sp)
    80001bda:	6442                	ld	s0,16(sp)
    80001bdc:	64a2                	ld	s1,8(sp)
    80001bde:	6105                	addi	sp,sp,32
    80001be0:	8082                	ret

0000000080001be2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be2:	1101                	addi	sp,sp,-32
    80001be4:	ec06                	sd	ra,24(sp)
    80001be6:	e822                	sd	s0,16(sp)
    80001be8:	e426                	sd	s1,8(sp)
    80001bea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bec:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf0:	00074d63          	bltz	a4,80001c0a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf4:	57fd                	li	a5,-1
    80001bf6:	17fe                	slli	a5,a5,0x3f
    80001bf8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bfa:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bfc:	06f70363          	beq	a4,a5,80001c62 <devintr+0x80>
  }
}
    80001c00:	60e2                	ld	ra,24(sp)
    80001c02:	6442                	ld	s0,16(sp)
    80001c04:	64a2                	ld	s1,8(sp)
    80001c06:	6105                	addi	sp,sp,32
    80001c08:	8082                	ret
     (scause & 0xff) == 9){
    80001c0a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c0e:	46a5                	li	a3,9
    80001c10:	fed792e3          	bne	a5,a3,80001bf4 <devintr+0x12>
    int irq = plic_claim();
    80001c14:	00003097          	auipc	ra,0x3
    80001c18:	4b4080e7          	jalr	1204(ra) # 800050c8 <plic_claim>
    80001c1c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c1e:	47a9                	li	a5,10
    80001c20:	02f50763          	beq	a0,a5,80001c4e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c24:	4785                	li	a5,1
    80001c26:	02f50963          	beq	a0,a5,80001c58 <devintr+0x76>
    return 1;
    80001c2a:	4505                	li	a0,1
    } else if(irq){
    80001c2c:	d8f1                	beqz	s1,80001c00 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2e:	85a6                	mv	a1,s1
    80001c30:	00006517          	auipc	a0,0x6
    80001c34:	65050513          	addi	a0,a0,1616 # 80008280 <states.0+0x38>
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	fa0080e7          	jalr	-96(ra) # 80005bd8 <printf>
      plic_complete(irq);
    80001c40:	8526                	mv	a0,s1
    80001c42:	00003097          	auipc	ra,0x3
    80001c46:	4aa080e7          	jalr	1194(ra) # 800050ec <plic_complete>
    return 1;
    80001c4a:	4505                	li	a0,1
    80001c4c:	bf55                	j	80001c00 <devintr+0x1e>
      uartintr();
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	39c080e7          	jalr	924(ra) # 80005fea <uartintr>
    80001c56:	b7ed                	j	80001c40 <devintr+0x5e>
      virtio_disk_intr();
    80001c58:	00004097          	auipc	ra,0x4
    80001c5c:	960080e7          	jalr	-1696(ra) # 800055b8 <virtio_disk_intr>
    80001c60:	b7c5                	j	80001c40 <devintr+0x5e>
    if(cpuid() == 0){
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	1c4080e7          	jalr	452(ra) # 80000e26 <cpuid>
    80001c6a:	c901                	beqz	a0,80001c7a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c70:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c72:	14479073          	csrw	sip,a5
    return 2;
    80001c76:	4509                	li	a0,2
    80001c78:	b761                	j	80001c00 <devintr+0x1e>
      clockintr();
    80001c7a:	00000097          	auipc	ra,0x0
    80001c7e:	f22080e7          	jalr	-222(ra) # 80001b9c <clockintr>
    80001c82:	b7ed                	j	80001c6c <devintr+0x8a>

0000000080001c84 <usertrap>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	e04a                	sd	s2,0(sp)
    80001c8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c90:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c94:	1007f793          	andi	a5,a5,256
    80001c98:	e3b1                	bnez	a5,80001cdc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9a:	00003797          	auipc	a5,0x3
    80001c9e:	32678793          	addi	a5,a5,806 # 80004fc0 <kernelvec>
    80001ca2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca6:	fffff097          	auipc	ra,0xfffff
    80001caa:	1ac080e7          	jalr	428(ra) # 80000e52 <myproc>
    80001cae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb2:	14102773          	csrr	a4,sepc
    80001cb6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cbc:	47a1                	li	a5,8
    80001cbe:	02f70763          	beq	a4,a5,80001cec <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	f20080e7          	jalr	-224(ra) # 80001be2 <devintr>
    80001cca:	892a                	mv	s2,a0
    80001ccc:	c151                	beqz	a0,80001d50 <usertrap+0xcc>
  if(killed(p))
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	ad2080e7          	jalr	-1326(ra) # 800017a2 <killed>
    80001cd8:	c929                	beqz	a0,80001d2a <usertrap+0xa6>
    80001cda:	a099                	j	80001d20 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5c450513          	addi	a0,a0,1476 # 800082a0 <states.0+0x58>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	eaa080e7          	jalr	-342(ra) # 80005b8e <panic>
    if(killed(p))
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	ab6080e7          	jalr	-1354(ra) # 800017a2 <killed>
    80001cf4:	e921                	bnez	a0,80001d44 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cf6:	6cb8                	ld	a4,88(s1)
    80001cf8:	6f1c                	ld	a5,24(a4)
    80001cfa:	0791                	addi	a5,a5,4
    80001cfc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d02:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d06:	10079073          	csrw	sstatus,a5
    syscall();
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	2d4080e7          	jalr	724(ra) # 80001fde <syscall>
  if(killed(p))
    80001d12:	8526                	mv	a0,s1
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	a8e080e7          	jalr	-1394(ra) # 800017a2 <killed>
    80001d1c:	c911                	beqz	a0,80001d30 <usertrap+0xac>
    80001d1e:	4901                	li	s2,0
    exit(-1);
    80001d20:	557d                	li	a0,-1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	90c080e7          	jalr	-1780(ra) # 8000162e <exit>
  if(which_dev == 2)
    80001d2a:	4789                	li	a5,2
    80001d2c:	04f90f63          	beq	s2,a5,80001d8a <usertrap+0x106>
  usertrapret();
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	dd6080e7          	jalr	-554(ra) # 80001b06 <usertrapret>
}
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6902                	ld	s2,0(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
      exit(-1);
    80001d44:	557d                	li	a0,-1
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	8e8080e7          	jalr	-1816(ra) # 8000162e <exit>
    80001d4e:	b765                	j	80001cf6 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d50:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d54:	5890                	lw	a2,48(s1)
    80001d56:	00006517          	auipc	a0,0x6
    80001d5a:	56a50513          	addi	a0,a0,1386 # 800082c0 <states.0+0x78>
    80001d5e:	00004097          	auipc	ra,0x4
    80001d62:	e7a080e7          	jalr	-390(ra) # 80005bd8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d66:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d6e:	00006517          	auipc	a0,0x6
    80001d72:	58250513          	addi	a0,a0,1410 # 800082f0 <states.0+0xa8>
    80001d76:	00004097          	auipc	ra,0x4
    80001d7a:	e62080e7          	jalr	-414(ra) # 80005bd8 <printf>
    setkilled(p);
    80001d7e:	8526                	mv	a0,s1
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	9f6080e7          	jalr	-1546(ra) # 80001776 <setkilled>
    80001d88:	b769                	j	80001d12 <usertrap+0x8e>
    yield();
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	734080e7          	jalr	1844(ra) # 800014be <yield>
    80001d92:	bf79                	j	80001d30 <usertrap+0xac>

0000000080001d94 <kerneltrap>:
{
    80001d94:	7179                	addi	sp,sp,-48
    80001d96:	f406                	sd	ra,40(sp)
    80001d98:	f022                	sd	s0,32(sp)
    80001d9a:	ec26                	sd	s1,24(sp)
    80001d9c:	e84a                	sd	s2,16(sp)
    80001d9e:	e44e                	sd	s3,8(sp)
    80001da0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001daa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dae:	1004f793          	andi	a5,s1,256
    80001db2:	cb85                	beqz	a5,80001de2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dba:	ef85                	bnez	a5,80001df2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	e26080e7          	jalr	-474(ra) # 80001be2 <devintr>
    80001dc4:	cd1d                	beqz	a0,80001e02 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc6:	4789                	li	a5,2
    80001dc8:	06f50a63          	beq	a0,a5,80001e3c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dcc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd0:	10049073          	csrw	sstatus,s1
}
    80001dd4:	70a2                	ld	ra,40(sp)
    80001dd6:	7402                	ld	s0,32(sp)
    80001dd8:	64e2                	ld	s1,24(sp)
    80001dda:	6942                	ld	s2,16(sp)
    80001ddc:	69a2                	ld	s3,8(sp)
    80001dde:	6145                	addi	sp,sp,48
    80001de0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	52e50513          	addi	a0,a0,1326 # 80008310 <states.0+0xc8>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	da4080e7          	jalr	-604(ra) # 80005b8e <panic>
    panic("kerneltrap: interrupts enabled");
    80001df2:	00006517          	auipc	a0,0x6
    80001df6:	54650513          	addi	a0,a0,1350 # 80008338 <states.0+0xf0>
    80001dfa:	00004097          	auipc	ra,0x4
    80001dfe:	d94080e7          	jalr	-620(ra) # 80005b8e <panic>
    printf("scause %p\n", scause);
    80001e02:	85ce                	mv	a1,s3
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	55450513          	addi	a0,a0,1364 # 80008358 <states.0+0x110>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	dcc080e7          	jalr	-564(ra) # 80005bd8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e14:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e18:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	54c50513          	addi	a0,a0,1356 # 80008368 <states.0+0x120>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	db4080e7          	jalr	-588(ra) # 80005bd8 <printf>
    panic("kerneltrap");
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	55450513          	addi	a0,a0,1364 # 80008380 <states.0+0x138>
    80001e34:	00004097          	auipc	ra,0x4
    80001e38:	d5a080e7          	jalr	-678(ra) # 80005b8e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	016080e7          	jalr	22(ra) # 80000e52 <myproc>
    80001e44:	d541                	beqz	a0,80001dcc <kerneltrap+0x38>
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	00c080e7          	jalr	12(ra) # 80000e52 <myproc>
    80001e4e:	4d18                	lw	a4,24(a0)
    80001e50:	4791                	li	a5,4
    80001e52:	f6f71de3          	bne	a4,a5,80001dcc <kerneltrap+0x38>
    yield();
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	668080e7          	jalr	1640(ra) # 800014be <yield>
    80001e5e:	b7bd                	j	80001dcc <kerneltrap+0x38>

0000000080001e60 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	1000                	addi	s0,sp,32
    80001e6a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	fe6080e7          	jalr	-26(ra) # 80000e52 <myproc>
  switch (n) {
    80001e74:	4795                	li	a5,5
    80001e76:	0497e163          	bltu	a5,s1,80001eb8 <argraw+0x58>
    80001e7a:	048a                	slli	s1,s1,0x2
    80001e7c:	00006717          	auipc	a4,0x6
    80001e80:	53c70713          	addi	a4,a4,1340 # 800083b8 <states.0+0x170>
    80001e84:	94ba                	add	s1,s1,a4
    80001e86:	409c                	lw	a5,0(s1)
    80001e88:	97ba                	add	a5,a5,a4
    80001e8a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8c:	6d3c                	ld	a5,88(a0)
    80001e8e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e90:	60e2                	ld	ra,24(sp)
    80001e92:	6442                	ld	s0,16(sp)
    80001e94:	64a2                	ld	s1,8(sp)
    80001e96:	6105                	addi	sp,sp,32
    80001e98:	8082                	ret
    return p->trapframe->a1;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	7fa8                	ld	a0,120(a5)
    80001e9e:	bfcd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a2;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	63c8                	ld	a0,128(a5)
    80001ea4:	b7f5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a3;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	67c8                	ld	a0,136(a5)
    80001eaa:	b7dd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a4;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	6bc8                	ld	a0,144(a5)
    80001eb0:	b7c5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a5;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	6fc8                	ld	a0,152(a5)
    80001eb6:	bfe9                	j	80001e90 <argraw+0x30>
  panic("argraw");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	4d850513          	addi	a0,a0,1240 # 80008390 <states.0+0x148>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	cce080e7          	jalr	-818(ra) # 80005b8e <panic>

0000000080001ec8 <fetchaddr>:
{
    80001ec8:	1101                	addi	sp,sp,-32
    80001eca:	ec06                	sd	ra,24(sp)
    80001ecc:	e822                	sd	s0,16(sp)
    80001ece:	e426                	sd	s1,8(sp)
    80001ed0:	e04a                	sd	s2,0(sp)
    80001ed2:	1000                	addi	s0,sp,32
    80001ed4:	84aa                	mv	s1,a0
    80001ed6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	f7a080e7          	jalr	-134(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee0:	653c                	ld	a5,72(a0)
    80001ee2:	02f4f863          	bgeu	s1,a5,80001f12 <fetchaddr+0x4a>
    80001ee6:	00848713          	addi	a4,s1,8
    80001eea:	02e7e663          	bltu	a5,a4,80001f16 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001eee:	46a1                	li	a3,8
    80001ef0:	8626                	mv	a2,s1
    80001ef2:	85ca                	mv	a1,s2
    80001ef4:	6928                	ld	a0,80(a0)
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	ca4080e7          	jalr	-860(ra) # 80000b9a <copyin>
    80001efe:	00a03533          	snez	a0,a0
    80001f02:	40a00533          	neg	a0,a0
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6902                	ld	s2,0(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret
    return -1;
    80001f12:	557d                	li	a0,-1
    80001f14:	bfcd                	j	80001f06 <fetchaddr+0x3e>
    80001f16:	557d                	li	a0,-1
    80001f18:	b7fd                	j	80001f06 <fetchaddr+0x3e>

0000000080001f1a <fetchstr>:
{
    80001f1a:	7179                	addi	sp,sp,-48
    80001f1c:	f406                	sd	ra,40(sp)
    80001f1e:	f022                	sd	s0,32(sp)
    80001f20:	ec26                	sd	s1,24(sp)
    80001f22:	e84a                	sd	s2,16(sp)
    80001f24:	e44e                	sd	s3,8(sp)
    80001f26:	1800                	addi	s0,sp,48
    80001f28:	892a                	mv	s2,a0
    80001f2a:	84ae                	mv	s1,a1
    80001f2c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	f24080e7          	jalr	-220(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f36:	86ce                	mv	a3,s3
    80001f38:	864a                	mv	a2,s2
    80001f3a:	85a6                	mv	a1,s1
    80001f3c:	6928                	ld	a0,80(a0)
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	cea080e7          	jalr	-790(ra) # 80000c28 <copyinstr>
    80001f46:	00054e63          	bltz	a0,80001f62 <fetchstr+0x48>
  return strlen(buf);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	ffffe097          	auipc	ra,0xffffe
    80001f50:	3a8080e7          	jalr	936(ra) # 800002f4 <strlen>
}
    80001f54:	70a2                	ld	ra,40(sp)
    80001f56:	7402                	ld	s0,32(sp)
    80001f58:	64e2                	ld	s1,24(sp)
    80001f5a:	6942                	ld	s2,16(sp)
    80001f5c:	69a2                	ld	s3,8(sp)
    80001f5e:	6145                	addi	sp,sp,48
    80001f60:	8082                	ret
    return -1;
    80001f62:	557d                	li	a0,-1
    80001f64:	bfc5                	j	80001f54 <fetchstr+0x3a>

0000000080001f66 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	1000                	addi	s0,sp,32
    80001f70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	eee080e7          	jalr	-274(ra) # 80001e60 <argraw>
    80001f7a:	c088                	sw	a0,0(s1)
}
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f86:	1101                	addi	sp,sp,-32
    80001f88:	ec06                	sd	ra,24(sp)
    80001f8a:	e822                	sd	s0,16(sp)
    80001f8c:	e426                	sd	s1,8(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	ece080e7          	jalr	-306(ra) # 80001e60 <argraw>
    80001f9a:	e088                	sd	a0,0(s1)
}
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa6:	7179                	addi	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	1800                	addi	s0,sp,48
    80001fb2:	84ae                	mv	s1,a1
    80001fb4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fb6:	fd840593          	addi	a1,s0,-40
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	fcc080e7          	jalr	-52(ra) # 80001f86 <argaddr>
  return fetchstr(addr, buf, max);
    80001fc2:	864a                	mv	a2,s2
    80001fc4:	85a6                	mv	a1,s1
    80001fc6:	fd843503          	ld	a0,-40(s0)
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	f50080e7          	jalr	-176(ra) # 80001f1a <fetchstr>
}
    80001fd2:	70a2                	ld	ra,40(sp)
    80001fd4:	7402                	ld	s0,32(sp)
    80001fd6:	64e2                	ld	s1,24(sp)
    80001fd8:	6942                	ld	s2,16(sp)
    80001fda:	6145                	addi	sp,sp,48
    80001fdc:	8082                	ret

0000000080001fde <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e68080e7          	jalr	-408(ra) # 80000e52 <myproc>
    80001ff2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff4:	05853903          	ld	s2,88(a0)
    80001ff8:	0a893783          	ld	a5,168(s2)
    80001ffc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002000:	37fd                	addiw	a5,a5,-1
    80002002:	4751                	li	a4,20
    80002004:	00f76f63          	bltu	a4,a5,80002022 <syscall+0x44>
    80002008:	00369713          	slli	a4,a3,0x3
    8000200c:	00006797          	auipc	a5,0x6
    80002010:	3c478793          	addi	a5,a5,964 # 800083d0 <syscalls>
    80002014:	97ba                	add	a5,a5,a4
    80002016:	639c                	ld	a5,0(a5)
    80002018:	c789                	beqz	a5,80002022 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000201a:	9782                	jalr	a5
    8000201c:	06a93823          	sd	a0,112(s2)
    80002020:	a839                	j	8000203e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002022:	15848613          	addi	a2,s1,344
    80002026:	588c                	lw	a1,48(s1)
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	37050513          	addi	a0,a0,880 # 80008398 <states.0+0x150>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	ba8080e7          	jalr	-1112(ra) # 80005bd8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002038:	6cbc                	ld	a5,88(s1)
    8000203a:	577d                	li	a4,-1
    8000203c:	fbb8                	sd	a4,112(a5)
  }
}
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002052:	fec40593          	addi	a1,s0,-20
    80002056:	4501                	li	a0,0
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	f0e080e7          	jalr	-242(ra) # 80001f66 <argint>
  exit(n);
    80002060:	fec42503          	lw	a0,-20(s0)
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	5ca080e7          	jalr	1482(ra) # 8000162e <exit>
  return 0;  // not reached
}
    8000206c:	4501                	li	a0,0
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	6105                	addi	sp,sp,32
    80002074:	8082                	ret

0000000080002076 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002076:	1141                	addi	sp,sp,-16
    80002078:	e406                	sd	ra,8(sp)
    8000207a:	e022                	sd	s0,0(sp)
    8000207c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	dd4080e7          	jalr	-556(ra) # 80000e52 <myproc>
}
    80002086:	5908                	lw	a0,48(a0)
    80002088:	60a2                	ld	ra,8(sp)
    8000208a:	6402                	ld	s0,0(sp)
    8000208c:	0141                	addi	sp,sp,16
    8000208e:	8082                	ret

0000000080002090 <sys_fork>:

uint64
sys_fork(void)
{
    80002090:	1141                	addi	sp,sp,-16
    80002092:	e406                	sd	ra,8(sp)
    80002094:	e022                	sd	s0,0(sp)
    80002096:	0800                	addi	s0,sp,16
  return fork();
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	170080e7          	jalr	368(ra) # 80001208 <fork>
}
    800020a0:	60a2                	ld	ra,8(sp)
    800020a2:	6402                	ld	s0,0(sp)
    800020a4:	0141                	addi	sp,sp,16
    800020a6:	8082                	ret

00000000800020a8 <sys_wait>:

uint64
sys_wait(void)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b0:	fe840593          	addi	a1,s0,-24
    800020b4:	4501                	li	a0,0
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	ed0080e7          	jalr	-304(ra) # 80001f86 <argaddr>
  return wait(p);
    800020be:	fe843503          	ld	a0,-24(s0)
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	712080e7          	jalr	1810(ra) # 800017d4 <wait>
}
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d2:	7179                	addi	sp,sp,-48
    800020d4:	f406                	sd	ra,40(sp)
    800020d6:	f022                	sd	s0,32(sp)
    800020d8:	ec26                	sd	s1,24(sp)
    800020da:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020dc:	fdc40593          	addi	a1,s0,-36
    800020e0:	4501                	li	a0,0
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	e84080e7          	jalr	-380(ra) # 80001f66 <argint>
  addr = myproc()->sz;
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	d68080e7          	jalr	-664(ra) # 80000e52 <myproc>
    800020f2:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020f4:	fdc42503          	lw	a0,-36(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	0b4080e7          	jalr	180(ra) # 800011ac <growproc>
    80002100:	00054863          	bltz	a0,80002110 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002104:	8526                	mv	a0,s1
    80002106:	70a2                	ld	ra,40(sp)
    80002108:	7402                	ld	s0,32(sp)
    8000210a:	64e2                	ld	s1,24(sp)
    8000210c:	6145                	addi	sp,sp,48
    8000210e:	8082                	ret
    return -1;
    80002110:	54fd                	li	s1,-1
    80002112:	bfcd                	j	80002104 <sys_sbrk+0x32>

0000000080002114 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002114:	7139                	addi	sp,sp,-64
    80002116:	fc06                	sd	ra,56(sp)
    80002118:	f822                	sd	s0,48(sp)
    8000211a:	f426                	sd	s1,40(sp)
    8000211c:	f04a                	sd	s2,32(sp)
    8000211e:	ec4e                	sd	s3,24(sp)
    80002120:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002122:	fcc40593          	addi	a1,s0,-52
    80002126:	4501                	li	a0,0
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	e3e080e7          	jalr	-450(ra) # 80001f66 <argint>
  if(n < 0)
    80002130:	fcc42783          	lw	a5,-52(s0)
    80002134:	0607cf63          	bltz	a5,800021b2 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002138:	0000c517          	auipc	a0,0xc
    8000213c:	5d850513          	addi	a0,a0,1496 # 8000e710 <tickslock>
    80002140:	00004097          	auipc	ra,0x4
    80002144:	f8a080e7          	jalr	-118(ra) # 800060ca <acquire>
  ticks0 = ticks;
    80002148:	00006917          	auipc	s2,0x6
    8000214c:	76092903          	lw	s2,1888(s2) # 800088a8 <ticks>
  while(ticks - ticks0 < n){
    80002150:	fcc42783          	lw	a5,-52(s0)
    80002154:	cf9d                	beqz	a5,80002192 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002156:	0000c997          	auipc	s3,0xc
    8000215a:	5ba98993          	addi	s3,s3,1466 # 8000e710 <tickslock>
    8000215e:	00006497          	auipc	s1,0x6
    80002162:	74a48493          	addi	s1,s1,1866 # 800088a8 <ticks>
    if(killed(myproc())){
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	cec080e7          	jalr	-788(ra) # 80000e52 <myproc>
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	634080e7          	jalr	1588(ra) # 800017a2 <killed>
    80002176:	e129                	bnez	a0,800021b8 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002178:	85ce                	mv	a1,s3
    8000217a:	8526                	mv	a0,s1
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	37e080e7          	jalr	894(ra) # 800014fa <sleep>
  while(ticks - ticks0 < n){
    80002184:	409c                	lw	a5,0(s1)
    80002186:	412787bb          	subw	a5,a5,s2
    8000218a:	fcc42703          	lw	a4,-52(s0)
    8000218e:	fce7ece3          	bltu	a5,a4,80002166 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002192:	0000c517          	auipc	a0,0xc
    80002196:	57e50513          	addi	a0,a0,1406 # 8000e710 <tickslock>
    8000219a:	00004097          	auipc	ra,0x4
    8000219e:	fe4080e7          	jalr	-28(ra) # 8000617e <release>
  return 0;
    800021a2:	4501                	li	a0,0
}
    800021a4:	70e2                	ld	ra,56(sp)
    800021a6:	7442                	ld	s0,48(sp)
    800021a8:	74a2                	ld	s1,40(sp)
    800021aa:	7902                	ld	s2,32(sp)
    800021ac:	69e2                	ld	s3,24(sp)
    800021ae:	6121                	addi	sp,sp,64
    800021b0:	8082                	ret
    n = 0;
    800021b2:	fc042623          	sw	zero,-52(s0)
    800021b6:	b749                	j	80002138 <sys_sleep+0x24>
      release(&tickslock);
    800021b8:	0000c517          	auipc	a0,0xc
    800021bc:	55850513          	addi	a0,a0,1368 # 8000e710 <tickslock>
    800021c0:	00004097          	auipc	ra,0x4
    800021c4:	fbe080e7          	jalr	-66(ra) # 8000617e <release>
      return -1;
    800021c8:	557d                	li	a0,-1
    800021ca:	bfe9                	j	800021a4 <sys_sleep+0x90>

00000000800021cc <sys_kill>:

uint64
sys_kill(void)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021d4:	fec40593          	addi	a1,s0,-20
    800021d8:	4501                	li	a0,0
    800021da:	00000097          	auipc	ra,0x0
    800021de:	d8c080e7          	jalr	-628(ra) # 80001f66 <argint>
  return kill(pid);
    800021e2:	fec42503          	lw	a0,-20(s0)
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	51e080e7          	jalr	1310(ra) # 80001704 <kill>
}
    800021ee:	60e2                	ld	ra,24(sp)
    800021f0:	6442                	ld	s0,16(sp)
    800021f2:	6105                	addi	sp,sp,32
    800021f4:	8082                	ret

00000000800021f6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	e426                	sd	s1,8(sp)
    800021fe:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002200:	0000c517          	auipc	a0,0xc
    80002204:	51050513          	addi	a0,a0,1296 # 8000e710 <tickslock>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	ec2080e7          	jalr	-318(ra) # 800060ca <acquire>
  xticks = ticks;
    80002210:	00006497          	auipc	s1,0x6
    80002214:	6984a483          	lw	s1,1688(s1) # 800088a8 <ticks>
  release(&tickslock);
    80002218:	0000c517          	auipc	a0,0xc
    8000221c:	4f850513          	addi	a0,a0,1272 # 8000e710 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	f5e080e7          	jalr	-162(ra) # 8000617e <release>
  return xticks;
}
    80002228:	02049513          	slli	a0,s1,0x20
    8000222c:	9101                	srli	a0,a0,0x20
    8000222e:	60e2                	ld	ra,24(sp)
    80002230:	6442                	ld	s0,16(sp)
    80002232:	64a2                	ld	s1,8(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002238:	7179                	addi	sp,sp,-48
    8000223a:	f406                	sd	ra,40(sp)
    8000223c:	f022                	sd	s0,32(sp)
    8000223e:	ec26                	sd	s1,24(sp)
    80002240:	e84a                	sd	s2,16(sp)
    80002242:	e44e                	sd	s3,8(sp)
    80002244:	e052                	sd	s4,0(sp)
    80002246:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002248:	00006597          	auipc	a1,0x6
    8000224c:	23858593          	addi	a1,a1,568 # 80008480 <syscalls+0xb0>
    80002250:	0000c517          	auipc	a0,0xc
    80002254:	4d850513          	addi	a0,a0,1240 # 8000e728 <bcache>
    80002258:	00004097          	auipc	ra,0x4
    8000225c:	de2080e7          	jalr	-542(ra) # 8000603a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002260:	00014797          	auipc	a5,0x14
    80002264:	4c878793          	addi	a5,a5,1224 # 80016728 <bcache+0x8000>
    80002268:	00014717          	auipc	a4,0x14
    8000226c:	72870713          	addi	a4,a4,1832 # 80016990 <bcache+0x8268>
    80002270:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002274:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002278:	0000c497          	auipc	s1,0xc
    8000227c:	4c848493          	addi	s1,s1,1224 # 8000e740 <bcache+0x18>
    b->next = bcache.head.next;
    80002280:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002282:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002284:	00006a17          	auipc	s4,0x6
    80002288:	204a0a13          	addi	s4,s4,516 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000228c:	2b893783          	ld	a5,696(s2)
    80002290:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002292:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002296:	85d2                	mv	a1,s4
    80002298:	01048513          	addi	a0,s1,16
    8000229c:	00001097          	auipc	ra,0x1
    800022a0:	4c4080e7          	jalr	1220(ra) # 80003760 <initsleeplock>
    bcache.head.next->prev = b;
    800022a4:	2b893783          	ld	a5,696(s2)
    800022a8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022aa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ae:	45848493          	addi	s1,s1,1112
    800022b2:	fd349de3          	bne	s1,s3,8000228c <binit+0x54>
  }
}
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6a02                	ld	s4,0(sp)
    800022c2:	6145                	addi	sp,sp,48
    800022c4:	8082                	ret

00000000800022c6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022c6:	7179                	addi	sp,sp,-48
    800022c8:	f406                	sd	ra,40(sp)
    800022ca:	f022                	sd	s0,32(sp)
    800022cc:	ec26                	sd	s1,24(sp)
    800022ce:	e84a                	sd	s2,16(sp)
    800022d0:	e44e                	sd	s3,8(sp)
    800022d2:	1800                	addi	s0,sp,48
    800022d4:	892a                	mv	s2,a0
    800022d6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022d8:	0000c517          	auipc	a0,0xc
    800022dc:	45050513          	addi	a0,a0,1104 # 8000e728 <bcache>
    800022e0:	00004097          	auipc	ra,0x4
    800022e4:	dea080e7          	jalr	-534(ra) # 800060ca <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022e8:	00014497          	auipc	s1,0x14
    800022ec:	6f84b483          	ld	s1,1784(s1) # 800169e0 <bcache+0x82b8>
    800022f0:	00014797          	auipc	a5,0x14
    800022f4:	6a078793          	addi	a5,a5,1696 # 80016990 <bcache+0x8268>
    800022f8:	02f48f63          	beq	s1,a5,80002336 <bread+0x70>
    800022fc:	873e                	mv	a4,a5
    800022fe:	a021                	j	80002306 <bread+0x40>
    80002300:	68a4                	ld	s1,80(s1)
    80002302:	02e48a63          	beq	s1,a4,80002336 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002306:	449c                	lw	a5,8(s1)
    80002308:	ff279ce3          	bne	a5,s2,80002300 <bread+0x3a>
    8000230c:	44dc                	lw	a5,12(s1)
    8000230e:	ff3799e3          	bne	a5,s3,80002300 <bread+0x3a>
      b->refcnt++;
    80002312:	40bc                	lw	a5,64(s1)
    80002314:	2785                	addiw	a5,a5,1
    80002316:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002318:	0000c517          	auipc	a0,0xc
    8000231c:	41050513          	addi	a0,a0,1040 # 8000e728 <bcache>
    80002320:	00004097          	auipc	ra,0x4
    80002324:	e5e080e7          	jalr	-418(ra) # 8000617e <release>
      acquiresleep(&b->lock);
    80002328:	01048513          	addi	a0,s1,16
    8000232c:	00001097          	auipc	ra,0x1
    80002330:	46e080e7          	jalr	1134(ra) # 8000379a <acquiresleep>
      return b;
    80002334:	a8b9                	j	80002392 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002336:	00014497          	auipc	s1,0x14
    8000233a:	6a24b483          	ld	s1,1698(s1) # 800169d8 <bcache+0x82b0>
    8000233e:	00014797          	auipc	a5,0x14
    80002342:	65278793          	addi	a5,a5,1618 # 80016990 <bcache+0x8268>
    80002346:	00f48863          	beq	s1,a5,80002356 <bread+0x90>
    8000234a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000234c:	40bc                	lw	a5,64(s1)
    8000234e:	cf81                	beqz	a5,80002366 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002350:	64a4                	ld	s1,72(s1)
    80002352:	fee49de3          	bne	s1,a4,8000234c <bread+0x86>
  panic("bget: no buffers");
    80002356:	00006517          	auipc	a0,0x6
    8000235a:	13a50513          	addi	a0,a0,314 # 80008490 <syscalls+0xc0>
    8000235e:	00004097          	auipc	ra,0x4
    80002362:	830080e7          	jalr	-2000(ra) # 80005b8e <panic>
      b->dev = dev;
    80002366:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000236a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000236e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002372:	4785                	li	a5,1
    80002374:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002376:	0000c517          	auipc	a0,0xc
    8000237a:	3b250513          	addi	a0,a0,946 # 8000e728 <bcache>
    8000237e:	00004097          	auipc	ra,0x4
    80002382:	e00080e7          	jalr	-512(ra) # 8000617e <release>
      acquiresleep(&b->lock);
    80002386:	01048513          	addi	a0,s1,16
    8000238a:	00001097          	auipc	ra,0x1
    8000238e:	410080e7          	jalr	1040(ra) # 8000379a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002392:	409c                	lw	a5,0(s1)
    80002394:	cb89                	beqz	a5,800023a6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002396:	8526                	mv	a0,s1
    80002398:	70a2                	ld	ra,40(sp)
    8000239a:	7402                	ld	s0,32(sp)
    8000239c:	64e2                	ld	s1,24(sp)
    8000239e:	6942                	ld	s2,16(sp)
    800023a0:	69a2                	ld	s3,8(sp)
    800023a2:	6145                	addi	sp,sp,48
    800023a4:	8082                	ret
    virtio_disk_rw(b, 0);
    800023a6:	4581                	li	a1,0
    800023a8:	8526                	mv	a0,s1
    800023aa:	00003097          	auipc	ra,0x3
    800023ae:	fda080e7          	jalr	-38(ra) # 80005384 <virtio_disk_rw>
    b->valid = 1;
    800023b2:	4785                	li	a5,1
    800023b4:	c09c                	sw	a5,0(s1)
  return b;
    800023b6:	b7c5                	j	80002396 <bread+0xd0>

00000000800023b8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023b8:	1101                	addi	sp,sp,-32
    800023ba:	ec06                	sd	ra,24(sp)
    800023bc:	e822                	sd	s0,16(sp)
    800023be:	e426                	sd	s1,8(sp)
    800023c0:	1000                	addi	s0,sp,32
    800023c2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c4:	0541                	addi	a0,a0,16
    800023c6:	00001097          	auipc	ra,0x1
    800023ca:	46e080e7          	jalr	1134(ra) # 80003834 <holdingsleep>
    800023ce:	cd01                	beqz	a0,800023e6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023d0:	4585                	li	a1,1
    800023d2:	8526                	mv	a0,s1
    800023d4:	00003097          	auipc	ra,0x3
    800023d8:	fb0080e7          	jalr	-80(ra) # 80005384 <virtio_disk_rw>
}
    800023dc:	60e2                	ld	ra,24(sp)
    800023de:	6442                	ld	s0,16(sp)
    800023e0:	64a2                	ld	s1,8(sp)
    800023e2:	6105                	addi	sp,sp,32
    800023e4:	8082                	ret
    panic("bwrite");
    800023e6:	00006517          	auipc	a0,0x6
    800023ea:	0c250513          	addi	a0,a0,194 # 800084a8 <syscalls+0xd8>
    800023ee:	00003097          	auipc	ra,0x3
    800023f2:	7a0080e7          	jalr	1952(ra) # 80005b8e <panic>

00000000800023f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023f6:	1101                	addi	sp,sp,-32
    800023f8:	ec06                	sd	ra,24(sp)
    800023fa:	e822                	sd	s0,16(sp)
    800023fc:	e426                	sd	s1,8(sp)
    800023fe:	e04a                	sd	s2,0(sp)
    80002400:	1000                	addi	s0,sp,32
    80002402:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002404:	01050913          	addi	s2,a0,16
    80002408:	854a                	mv	a0,s2
    8000240a:	00001097          	auipc	ra,0x1
    8000240e:	42a080e7          	jalr	1066(ra) # 80003834 <holdingsleep>
    80002412:	c92d                	beqz	a0,80002484 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002414:	854a                	mv	a0,s2
    80002416:	00001097          	auipc	ra,0x1
    8000241a:	3da080e7          	jalr	986(ra) # 800037f0 <releasesleep>

  acquire(&bcache.lock);
    8000241e:	0000c517          	auipc	a0,0xc
    80002422:	30a50513          	addi	a0,a0,778 # 8000e728 <bcache>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	ca4080e7          	jalr	-860(ra) # 800060ca <acquire>
  b->refcnt--;
    8000242e:	40bc                	lw	a5,64(s1)
    80002430:	37fd                	addiw	a5,a5,-1
    80002432:	0007871b          	sext.w	a4,a5
    80002436:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002438:	eb05                	bnez	a4,80002468 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000243a:	68bc                	ld	a5,80(s1)
    8000243c:	64b8                	ld	a4,72(s1)
    8000243e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002440:	64bc                	ld	a5,72(s1)
    80002442:	68b8                	ld	a4,80(s1)
    80002444:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002446:	00014797          	auipc	a5,0x14
    8000244a:	2e278793          	addi	a5,a5,738 # 80016728 <bcache+0x8000>
    8000244e:	2b87b703          	ld	a4,696(a5)
    80002452:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002454:	00014717          	auipc	a4,0x14
    80002458:	53c70713          	addi	a4,a4,1340 # 80016990 <bcache+0x8268>
    8000245c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000245e:	2b87b703          	ld	a4,696(a5)
    80002462:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002464:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002468:	0000c517          	auipc	a0,0xc
    8000246c:	2c050513          	addi	a0,a0,704 # 8000e728 <bcache>
    80002470:	00004097          	auipc	ra,0x4
    80002474:	d0e080e7          	jalr	-754(ra) # 8000617e <release>
}
    80002478:	60e2                	ld	ra,24(sp)
    8000247a:	6442                	ld	s0,16(sp)
    8000247c:	64a2                	ld	s1,8(sp)
    8000247e:	6902                	ld	s2,0(sp)
    80002480:	6105                	addi	sp,sp,32
    80002482:	8082                	ret
    panic("brelse");
    80002484:	00006517          	auipc	a0,0x6
    80002488:	02c50513          	addi	a0,a0,44 # 800084b0 <syscalls+0xe0>
    8000248c:	00003097          	auipc	ra,0x3
    80002490:	702080e7          	jalr	1794(ra) # 80005b8e <panic>

0000000080002494 <bpin>:

void
bpin(struct buf *b) {
    80002494:	1101                	addi	sp,sp,-32
    80002496:	ec06                	sd	ra,24(sp)
    80002498:	e822                	sd	s0,16(sp)
    8000249a:	e426                	sd	s1,8(sp)
    8000249c:	1000                	addi	s0,sp,32
    8000249e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024a0:	0000c517          	auipc	a0,0xc
    800024a4:	28850513          	addi	a0,a0,648 # 8000e728 <bcache>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	c22080e7          	jalr	-990(ra) # 800060ca <acquire>
  b->refcnt++;
    800024b0:	40bc                	lw	a5,64(s1)
    800024b2:	2785                	addiw	a5,a5,1
    800024b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024b6:	0000c517          	auipc	a0,0xc
    800024ba:	27250513          	addi	a0,a0,626 # 8000e728 <bcache>
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	cc0080e7          	jalr	-832(ra) # 8000617e <release>
}
    800024c6:	60e2                	ld	ra,24(sp)
    800024c8:	6442                	ld	s0,16(sp)
    800024ca:	64a2                	ld	s1,8(sp)
    800024cc:	6105                	addi	sp,sp,32
    800024ce:	8082                	ret

00000000800024d0 <bunpin>:

void
bunpin(struct buf *b) {
    800024d0:	1101                	addi	sp,sp,-32
    800024d2:	ec06                	sd	ra,24(sp)
    800024d4:	e822                	sd	s0,16(sp)
    800024d6:	e426                	sd	s1,8(sp)
    800024d8:	1000                	addi	s0,sp,32
    800024da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024dc:	0000c517          	auipc	a0,0xc
    800024e0:	24c50513          	addi	a0,a0,588 # 8000e728 <bcache>
    800024e4:	00004097          	auipc	ra,0x4
    800024e8:	be6080e7          	jalr	-1050(ra) # 800060ca <acquire>
  b->refcnt--;
    800024ec:	40bc                	lw	a5,64(s1)
    800024ee:	37fd                	addiw	a5,a5,-1
    800024f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024f2:	0000c517          	auipc	a0,0xc
    800024f6:	23650513          	addi	a0,a0,566 # 8000e728 <bcache>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	c84080e7          	jalr	-892(ra) # 8000617e <release>
}
    80002502:	60e2                	ld	ra,24(sp)
    80002504:	6442                	ld	s0,16(sp)
    80002506:	64a2                	ld	s1,8(sp)
    80002508:	6105                	addi	sp,sp,32
    8000250a:	8082                	ret

000000008000250c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000250c:	1101                	addi	sp,sp,-32
    8000250e:	ec06                	sd	ra,24(sp)
    80002510:	e822                	sd	s0,16(sp)
    80002512:	e426                	sd	s1,8(sp)
    80002514:	e04a                	sd	s2,0(sp)
    80002516:	1000                	addi	s0,sp,32
    80002518:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000251a:	00d5d59b          	srliw	a1,a1,0xd
    8000251e:	00015797          	auipc	a5,0x15
    80002522:	8e67a783          	lw	a5,-1818(a5) # 80016e04 <sb+0x1c>
    80002526:	9dbd                	addw	a1,a1,a5
    80002528:	00000097          	auipc	ra,0x0
    8000252c:	d9e080e7          	jalr	-610(ra) # 800022c6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002530:	0074f713          	andi	a4,s1,7
    80002534:	4785                	li	a5,1
    80002536:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000253a:	14ce                	slli	s1,s1,0x33
    8000253c:	90d9                	srli	s1,s1,0x36
    8000253e:	00950733          	add	a4,a0,s1
    80002542:	05874703          	lbu	a4,88(a4)
    80002546:	00e7f6b3          	and	a3,a5,a4
    8000254a:	c69d                	beqz	a3,80002578 <bfree+0x6c>
    8000254c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000254e:	94aa                	add	s1,s1,a0
    80002550:	fff7c793          	not	a5,a5
    80002554:	8ff9                	and	a5,a5,a4
    80002556:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000255a:	00001097          	auipc	ra,0x1
    8000255e:	120080e7          	jalr	288(ra) # 8000367a <log_write>
  brelse(bp);
    80002562:	854a                	mv	a0,s2
    80002564:	00000097          	auipc	ra,0x0
    80002568:	e92080e7          	jalr	-366(ra) # 800023f6 <brelse>
}
    8000256c:	60e2                	ld	ra,24(sp)
    8000256e:	6442                	ld	s0,16(sp)
    80002570:	64a2                	ld	s1,8(sp)
    80002572:	6902                	ld	s2,0(sp)
    80002574:	6105                	addi	sp,sp,32
    80002576:	8082                	ret
    panic("freeing free block");
    80002578:	00006517          	auipc	a0,0x6
    8000257c:	f4050513          	addi	a0,a0,-192 # 800084b8 <syscalls+0xe8>
    80002580:	00003097          	auipc	ra,0x3
    80002584:	60e080e7          	jalr	1550(ra) # 80005b8e <panic>

0000000080002588 <balloc>:
{
    80002588:	711d                	addi	sp,sp,-96
    8000258a:	ec86                	sd	ra,88(sp)
    8000258c:	e8a2                	sd	s0,80(sp)
    8000258e:	e4a6                	sd	s1,72(sp)
    80002590:	e0ca                	sd	s2,64(sp)
    80002592:	fc4e                	sd	s3,56(sp)
    80002594:	f852                	sd	s4,48(sp)
    80002596:	f456                	sd	s5,40(sp)
    80002598:	f05a                	sd	s6,32(sp)
    8000259a:	ec5e                	sd	s7,24(sp)
    8000259c:	e862                	sd	s8,16(sp)
    8000259e:	e466                	sd	s9,8(sp)
    800025a0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025a2:	00015797          	auipc	a5,0x15
    800025a6:	84a7a783          	lw	a5,-1974(a5) # 80016dec <sb+0x4>
    800025aa:	10078163          	beqz	a5,800026ac <balloc+0x124>
    800025ae:	8baa                	mv	s7,a0
    800025b0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025b2:	00015b17          	auipc	s6,0x15
    800025b6:	836b0b13          	addi	s6,s6,-1994 # 80016de8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ba:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025bc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025be:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025c0:	6c89                	lui	s9,0x2
    800025c2:	a061                	j	8000264a <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025c4:	974a                	add	a4,a4,s2
    800025c6:	8fd5                	or	a5,a5,a3
    800025c8:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025cc:	854a                	mv	a0,s2
    800025ce:	00001097          	auipc	ra,0x1
    800025d2:	0ac080e7          	jalr	172(ra) # 8000367a <log_write>
        brelse(bp);
    800025d6:	854a                	mv	a0,s2
    800025d8:	00000097          	auipc	ra,0x0
    800025dc:	e1e080e7          	jalr	-482(ra) # 800023f6 <brelse>
  bp = bread(dev, bno);
    800025e0:	85a6                	mv	a1,s1
    800025e2:	855e                	mv	a0,s7
    800025e4:	00000097          	auipc	ra,0x0
    800025e8:	ce2080e7          	jalr	-798(ra) # 800022c6 <bread>
    800025ec:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025ee:	40000613          	li	a2,1024
    800025f2:	4581                	li	a1,0
    800025f4:	05850513          	addi	a0,a0,88
    800025f8:	ffffe097          	auipc	ra,0xffffe
    800025fc:	b80080e7          	jalr	-1152(ra) # 80000178 <memset>
  log_write(bp);
    80002600:	854a                	mv	a0,s2
    80002602:	00001097          	auipc	ra,0x1
    80002606:	078080e7          	jalr	120(ra) # 8000367a <log_write>
  brelse(bp);
    8000260a:	854a                	mv	a0,s2
    8000260c:	00000097          	auipc	ra,0x0
    80002610:	dea080e7          	jalr	-534(ra) # 800023f6 <brelse>
}
    80002614:	8526                	mv	a0,s1
    80002616:	60e6                	ld	ra,88(sp)
    80002618:	6446                	ld	s0,80(sp)
    8000261a:	64a6                	ld	s1,72(sp)
    8000261c:	6906                	ld	s2,64(sp)
    8000261e:	79e2                	ld	s3,56(sp)
    80002620:	7a42                	ld	s4,48(sp)
    80002622:	7aa2                	ld	s5,40(sp)
    80002624:	7b02                	ld	s6,32(sp)
    80002626:	6be2                	ld	s7,24(sp)
    80002628:	6c42                	ld	s8,16(sp)
    8000262a:	6ca2                	ld	s9,8(sp)
    8000262c:	6125                	addi	sp,sp,96
    8000262e:	8082                	ret
    brelse(bp);
    80002630:	854a                	mv	a0,s2
    80002632:	00000097          	auipc	ra,0x0
    80002636:	dc4080e7          	jalr	-572(ra) # 800023f6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000263a:	015c87bb          	addw	a5,s9,s5
    8000263e:	00078a9b          	sext.w	s5,a5
    80002642:	004b2703          	lw	a4,4(s6)
    80002646:	06eaf363          	bgeu	s5,a4,800026ac <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000264a:	41fad79b          	sraiw	a5,s5,0x1f
    8000264e:	0137d79b          	srliw	a5,a5,0x13
    80002652:	015787bb          	addw	a5,a5,s5
    80002656:	40d7d79b          	sraiw	a5,a5,0xd
    8000265a:	01cb2583          	lw	a1,28(s6)
    8000265e:	9dbd                	addw	a1,a1,a5
    80002660:	855e                	mv	a0,s7
    80002662:	00000097          	auipc	ra,0x0
    80002666:	c64080e7          	jalr	-924(ra) # 800022c6 <bread>
    8000266a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000266c:	004b2503          	lw	a0,4(s6)
    80002670:	000a849b          	sext.w	s1,s5
    80002674:	8662                	mv	a2,s8
    80002676:	faa4fde3          	bgeu	s1,a0,80002630 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000267a:	41f6579b          	sraiw	a5,a2,0x1f
    8000267e:	01d7d69b          	srliw	a3,a5,0x1d
    80002682:	00c6873b          	addw	a4,a3,a2
    80002686:	00777793          	andi	a5,a4,7
    8000268a:	9f95                	subw	a5,a5,a3
    8000268c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002690:	4037571b          	sraiw	a4,a4,0x3
    80002694:	00e906b3          	add	a3,s2,a4
    80002698:	0586c683          	lbu	a3,88(a3)
    8000269c:	00d7f5b3          	and	a1,a5,a3
    800026a0:	d195                	beqz	a1,800025c4 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a2:	2605                	addiw	a2,a2,1
    800026a4:	2485                	addiw	s1,s1,1
    800026a6:	fd4618e3          	bne	a2,s4,80002676 <balloc+0xee>
    800026aa:	b759                	j	80002630 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800026ac:	00006517          	auipc	a0,0x6
    800026b0:	e2450513          	addi	a0,a0,-476 # 800084d0 <syscalls+0x100>
    800026b4:	00003097          	auipc	ra,0x3
    800026b8:	524080e7          	jalr	1316(ra) # 80005bd8 <printf>
  return 0;
    800026bc:	4481                	li	s1,0
    800026be:	bf99                	j	80002614 <balloc+0x8c>

00000000800026c0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026c0:	7179                	addi	sp,sp,-48
    800026c2:	f406                	sd	ra,40(sp)
    800026c4:	f022                	sd	s0,32(sp)
    800026c6:	ec26                	sd	s1,24(sp)
    800026c8:	e84a                	sd	s2,16(sp)
    800026ca:	e44e                	sd	s3,8(sp)
    800026cc:	e052                	sd	s4,0(sp)
    800026ce:	1800                	addi	s0,sp,48
    800026d0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026d2:	47ad                	li	a5,11
    800026d4:	02b7e763          	bltu	a5,a1,80002702 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800026d8:	02059493          	slli	s1,a1,0x20
    800026dc:	9081                	srli	s1,s1,0x20
    800026de:	048a                	slli	s1,s1,0x2
    800026e0:	94aa                	add	s1,s1,a0
    800026e2:	0504a903          	lw	s2,80(s1)
    800026e6:	06091e63          	bnez	s2,80002762 <bmap+0xa2>
      addr = balloc(ip->dev);
    800026ea:	4108                	lw	a0,0(a0)
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	e9c080e7          	jalr	-356(ra) # 80002588 <balloc>
    800026f4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026f8:	06090563          	beqz	s2,80002762 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800026fc:	0524a823          	sw	s2,80(s1)
    80002700:	a08d                	j	80002762 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002702:	ff45849b          	addiw	s1,a1,-12
    80002706:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000270a:	0ff00793          	li	a5,255
    8000270e:	08e7e563          	bltu	a5,a4,80002798 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002712:	08052903          	lw	s2,128(a0)
    80002716:	00091d63          	bnez	s2,80002730 <bmap+0x70>
      addr = balloc(ip->dev);
    8000271a:	4108                	lw	a0,0(a0)
    8000271c:	00000097          	auipc	ra,0x0
    80002720:	e6c080e7          	jalr	-404(ra) # 80002588 <balloc>
    80002724:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002728:	02090d63          	beqz	s2,80002762 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000272c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002730:	85ca                	mv	a1,s2
    80002732:	0009a503          	lw	a0,0(s3)
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	b90080e7          	jalr	-1136(ra) # 800022c6 <bread>
    8000273e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002740:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002744:	02049593          	slli	a1,s1,0x20
    80002748:	9181                	srli	a1,a1,0x20
    8000274a:	058a                	slli	a1,a1,0x2
    8000274c:	00b784b3          	add	s1,a5,a1
    80002750:	0004a903          	lw	s2,0(s1)
    80002754:	02090063          	beqz	s2,80002774 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002758:	8552                	mv	a0,s4
    8000275a:	00000097          	auipc	ra,0x0
    8000275e:	c9c080e7          	jalr	-868(ra) # 800023f6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002762:	854a                	mv	a0,s2
    80002764:	70a2                	ld	ra,40(sp)
    80002766:	7402                	ld	s0,32(sp)
    80002768:	64e2                	ld	s1,24(sp)
    8000276a:	6942                	ld	s2,16(sp)
    8000276c:	69a2                	ld	s3,8(sp)
    8000276e:	6a02                	ld	s4,0(sp)
    80002770:	6145                	addi	sp,sp,48
    80002772:	8082                	ret
      addr = balloc(ip->dev);
    80002774:	0009a503          	lw	a0,0(s3)
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	e10080e7          	jalr	-496(ra) # 80002588 <balloc>
    80002780:	0005091b          	sext.w	s2,a0
      if(addr){
    80002784:	fc090ae3          	beqz	s2,80002758 <bmap+0x98>
        a[bn] = addr;
    80002788:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000278c:	8552                	mv	a0,s4
    8000278e:	00001097          	auipc	ra,0x1
    80002792:	eec080e7          	jalr	-276(ra) # 8000367a <log_write>
    80002796:	b7c9                	j	80002758 <bmap+0x98>
  panic("bmap: out of range");
    80002798:	00006517          	auipc	a0,0x6
    8000279c:	d5050513          	addi	a0,a0,-688 # 800084e8 <syscalls+0x118>
    800027a0:	00003097          	auipc	ra,0x3
    800027a4:	3ee080e7          	jalr	1006(ra) # 80005b8e <panic>

00000000800027a8 <iget>:
{
    800027a8:	7179                	addi	sp,sp,-48
    800027aa:	f406                	sd	ra,40(sp)
    800027ac:	f022                	sd	s0,32(sp)
    800027ae:	ec26                	sd	s1,24(sp)
    800027b0:	e84a                	sd	s2,16(sp)
    800027b2:	e44e                	sd	s3,8(sp)
    800027b4:	e052                	sd	s4,0(sp)
    800027b6:	1800                	addi	s0,sp,48
    800027b8:	89aa                	mv	s3,a0
    800027ba:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027bc:	00014517          	auipc	a0,0x14
    800027c0:	64c50513          	addi	a0,a0,1612 # 80016e08 <itable>
    800027c4:	00004097          	auipc	ra,0x4
    800027c8:	906080e7          	jalr	-1786(ra) # 800060ca <acquire>
  empty = 0;
    800027cc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027ce:	00014497          	auipc	s1,0x14
    800027d2:	65248493          	addi	s1,s1,1618 # 80016e20 <itable+0x18>
    800027d6:	00016697          	auipc	a3,0x16
    800027da:	0da68693          	addi	a3,a3,218 # 800188b0 <log>
    800027de:	a039                	j	800027ec <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027e0:	02090b63          	beqz	s2,80002816 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e4:	08848493          	addi	s1,s1,136
    800027e8:	02d48a63          	beq	s1,a3,8000281c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027ec:	449c                	lw	a5,8(s1)
    800027ee:	fef059e3          	blez	a5,800027e0 <iget+0x38>
    800027f2:	4098                	lw	a4,0(s1)
    800027f4:	ff3716e3          	bne	a4,s3,800027e0 <iget+0x38>
    800027f8:	40d8                	lw	a4,4(s1)
    800027fa:	ff4713e3          	bne	a4,s4,800027e0 <iget+0x38>
      ip->ref++;
    800027fe:	2785                	addiw	a5,a5,1
    80002800:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002802:	00014517          	auipc	a0,0x14
    80002806:	60650513          	addi	a0,a0,1542 # 80016e08 <itable>
    8000280a:	00004097          	auipc	ra,0x4
    8000280e:	974080e7          	jalr	-1676(ra) # 8000617e <release>
      return ip;
    80002812:	8926                	mv	s2,s1
    80002814:	a03d                	j	80002842 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002816:	f7f9                	bnez	a5,800027e4 <iget+0x3c>
    80002818:	8926                	mv	s2,s1
    8000281a:	b7e9                	j	800027e4 <iget+0x3c>
  if(empty == 0)
    8000281c:	02090c63          	beqz	s2,80002854 <iget+0xac>
  ip->dev = dev;
    80002820:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002824:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002828:	4785                	li	a5,1
    8000282a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000282e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002832:	00014517          	auipc	a0,0x14
    80002836:	5d650513          	addi	a0,a0,1494 # 80016e08 <itable>
    8000283a:	00004097          	auipc	ra,0x4
    8000283e:	944080e7          	jalr	-1724(ra) # 8000617e <release>
}
    80002842:	854a                	mv	a0,s2
    80002844:	70a2                	ld	ra,40(sp)
    80002846:	7402                	ld	s0,32(sp)
    80002848:	64e2                	ld	s1,24(sp)
    8000284a:	6942                	ld	s2,16(sp)
    8000284c:	69a2                	ld	s3,8(sp)
    8000284e:	6a02                	ld	s4,0(sp)
    80002850:	6145                	addi	sp,sp,48
    80002852:	8082                	ret
    panic("iget: no inodes");
    80002854:	00006517          	auipc	a0,0x6
    80002858:	cac50513          	addi	a0,a0,-852 # 80008500 <syscalls+0x130>
    8000285c:	00003097          	auipc	ra,0x3
    80002860:	332080e7          	jalr	818(ra) # 80005b8e <panic>

0000000080002864 <fsinit>:
fsinit(int dev) {
    80002864:	7179                	addi	sp,sp,-48
    80002866:	f406                	sd	ra,40(sp)
    80002868:	f022                	sd	s0,32(sp)
    8000286a:	ec26                	sd	s1,24(sp)
    8000286c:	e84a                	sd	s2,16(sp)
    8000286e:	e44e                	sd	s3,8(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002874:	4585                	li	a1,1
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	a50080e7          	jalr	-1456(ra) # 800022c6 <bread>
    8000287e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002880:	00014997          	auipc	s3,0x14
    80002884:	56898993          	addi	s3,s3,1384 # 80016de8 <sb>
    80002888:	02000613          	li	a2,32
    8000288c:	05850593          	addi	a1,a0,88
    80002890:	854e                	mv	a0,s3
    80002892:	ffffe097          	auipc	ra,0xffffe
    80002896:	942080e7          	jalr	-1726(ra) # 800001d4 <memmove>
  brelse(bp);
    8000289a:	8526                	mv	a0,s1
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	b5a080e7          	jalr	-1190(ra) # 800023f6 <brelse>
  if(sb.magic != FSMAGIC)
    800028a4:	0009a703          	lw	a4,0(s3)
    800028a8:	102037b7          	lui	a5,0x10203
    800028ac:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028b0:	02f71263          	bne	a4,a5,800028d4 <fsinit+0x70>
  initlog(dev, &sb);
    800028b4:	00014597          	auipc	a1,0x14
    800028b8:	53458593          	addi	a1,a1,1332 # 80016de8 <sb>
    800028bc:	854a                	mv	a0,s2
    800028be:	00001097          	auipc	ra,0x1
    800028c2:	b40080e7          	jalr	-1216(ra) # 800033fe <initlog>
}
    800028c6:	70a2                	ld	ra,40(sp)
    800028c8:	7402                	ld	s0,32(sp)
    800028ca:	64e2                	ld	s1,24(sp)
    800028cc:	6942                	ld	s2,16(sp)
    800028ce:	69a2                	ld	s3,8(sp)
    800028d0:	6145                	addi	sp,sp,48
    800028d2:	8082                	ret
    panic("invalid file system");
    800028d4:	00006517          	auipc	a0,0x6
    800028d8:	c3c50513          	addi	a0,a0,-964 # 80008510 <syscalls+0x140>
    800028dc:	00003097          	auipc	ra,0x3
    800028e0:	2b2080e7          	jalr	690(ra) # 80005b8e <panic>

00000000800028e4 <iinit>:
{
    800028e4:	7179                	addi	sp,sp,-48
    800028e6:	f406                	sd	ra,40(sp)
    800028e8:	f022                	sd	s0,32(sp)
    800028ea:	ec26                	sd	s1,24(sp)
    800028ec:	e84a                	sd	s2,16(sp)
    800028ee:	e44e                	sd	s3,8(sp)
    800028f0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028f2:	00006597          	auipc	a1,0x6
    800028f6:	c3658593          	addi	a1,a1,-970 # 80008528 <syscalls+0x158>
    800028fa:	00014517          	auipc	a0,0x14
    800028fe:	50e50513          	addi	a0,a0,1294 # 80016e08 <itable>
    80002902:	00003097          	auipc	ra,0x3
    80002906:	738080e7          	jalr	1848(ra) # 8000603a <initlock>
  for(i = 0; i < NINODE; i++) {
    8000290a:	00014497          	auipc	s1,0x14
    8000290e:	52648493          	addi	s1,s1,1318 # 80016e30 <itable+0x28>
    80002912:	00016997          	auipc	s3,0x16
    80002916:	fae98993          	addi	s3,s3,-82 # 800188c0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000291a:	00006917          	auipc	s2,0x6
    8000291e:	c1690913          	addi	s2,s2,-1002 # 80008530 <syscalls+0x160>
    80002922:	85ca                	mv	a1,s2
    80002924:	8526                	mv	a0,s1
    80002926:	00001097          	auipc	ra,0x1
    8000292a:	e3a080e7          	jalr	-454(ra) # 80003760 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000292e:	08848493          	addi	s1,s1,136
    80002932:	ff3498e3          	bne	s1,s3,80002922 <iinit+0x3e>
}
    80002936:	70a2                	ld	ra,40(sp)
    80002938:	7402                	ld	s0,32(sp)
    8000293a:	64e2                	ld	s1,24(sp)
    8000293c:	6942                	ld	s2,16(sp)
    8000293e:	69a2                	ld	s3,8(sp)
    80002940:	6145                	addi	sp,sp,48
    80002942:	8082                	ret

0000000080002944 <ialloc>:
{
    80002944:	715d                	addi	sp,sp,-80
    80002946:	e486                	sd	ra,72(sp)
    80002948:	e0a2                	sd	s0,64(sp)
    8000294a:	fc26                	sd	s1,56(sp)
    8000294c:	f84a                	sd	s2,48(sp)
    8000294e:	f44e                	sd	s3,40(sp)
    80002950:	f052                	sd	s4,32(sp)
    80002952:	ec56                	sd	s5,24(sp)
    80002954:	e85a                	sd	s6,16(sp)
    80002956:	e45e                	sd	s7,8(sp)
    80002958:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000295a:	00014717          	auipc	a4,0x14
    8000295e:	49a72703          	lw	a4,1178(a4) # 80016df4 <sb+0xc>
    80002962:	4785                	li	a5,1
    80002964:	04e7fa63          	bgeu	a5,a4,800029b8 <ialloc+0x74>
    80002968:	8aaa                	mv	s5,a0
    8000296a:	8bae                	mv	s7,a1
    8000296c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000296e:	00014a17          	auipc	s4,0x14
    80002972:	47aa0a13          	addi	s4,s4,1146 # 80016de8 <sb>
    80002976:	00048b1b          	sext.w	s6,s1
    8000297a:	0044d793          	srli	a5,s1,0x4
    8000297e:	018a2583          	lw	a1,24(s4)
    80002982:	9dbd                	addw	a1,a1,a5
    80002984:	8556                	mv	a0,s5
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	940080e7          	jalr	-1728(ra) # 800022c6 <bread>
    8000298e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002990:	05850993          	addi	s3,a0,88
    80002994:	00f4f793          	andi	a5,s1,15
    80002998:	079a                	slli	a5,a5,0x6
    8000299a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000299c:	00099783          	lh	a5,0(s3)
    800029a0:	c3a1                	beqz	a5,800029e0 <ialloc+0x9c>
    brelse(bp);
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	a54080e7          	jalr	-1452(ra) # 800023f6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029aa:	0485                	addi	s1,s1,1
    800029ac:	00ca2703          	lw	a4,12(s4)
    800029b0:	0004879b          	sext.w	a5,s1
    800029b4:	fce7e1e3          	bltu	a5,a4,80002976 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	b8050513          	addi	a0,a0,-1152 # 80008538 <syscalls+0x168>
    800029c0:	00003097          	auipc	ra,0x3
    800029c4:	218080e7          	jalr	536(ra) # 80005bd8 <printf>
  return 0;
    800029c8:	4501                	li	a0,0
}
    800029ca:	60a6                	ld	ra,72(sp)
    800029cc:	6406                	ld	s0,64(sp)
    800029ce:	74e2                	ld	s1,56(sp)
    800029d0:	7942                	ld	s2,48(sp)
    800029d2:	79a2                	ld	s3,40(sp)
    800029d4:	7a02                	ld	s4,32(sp)
    800029d6:	6ae2                	ld	s5,24(sp)
    800029d8:	6b42                	ld	s6,16(sp)
    800029da:	6ba2                	ld	s7,8(sp)
    800029dc:	6161                	addi	sp,sp,80
    800029de:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029e0:	04000613          	li	a2,64
    800029e4:	4581                	li	a1,0
    800029e6:	854e                	mv	a0,s3
    800029e8:	ffffd097          	auipc	ra,0xffffd
    800029ec:	790080e7          	jalr	1936(ra) # 80000178 <memset>
      dip->type = type;
    800029f0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029f4:	854a                	mv	a0,s2
    800029f6:	00001097          	auipc	ra,0x1
    800029fa:	c84080e7          	jalr	-892(ra) # 8000367a <log_write>
      brelse(bp);
    800029fe:	854a                	mv	a0,s2
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	9f6080e7          	jalr	-1546(ra) # 800023f6 <brelse>
      return iget(dev, inum);
    80002a08:	85da                	mv	a1,s6
    80002a0a:	8556                	mv	a0,s5
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	d9c080e7          	jalr	-612(ra) # 800027a8 <iget>
    80002a14:	bf5d                	j	800029ca <ialloc+0x86>

0000000080002a16 <iupdate>:
{
    80002a16:	1101                	addi	sp,sp,-32
    80002a18:	ec06                	sd	ra,24(sp)
    80002a1a:	e822                	sd	s0,16(sp)
    80002a1c:	e426                	sd	s1,8(sp)
    80002a1e:	e04a                	sd	s2,0(sp)
    80002a20:	1000                	addi	s0,sp,32
    80002a22:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a24:	415c                	lw	a5,4(a0)
    80002a26:	0047d79b          	srliw	a5,a5,0x4
    80002a2a:	00014597          	auipc	a1,0x14
    80002a2e:	3d65a583          	lw	a1,982(a1) # 80016e00 <sb+0x18>
    80002a32:	9dbd                	addw	a1,a1,a5
    80002a34:	4108                	lw	a0,0(a0)
    80002a36:	00000097          	auipc	ra,0x0
    80002a3a:	890080e7          	jalr	-1904(ra) # 800022c6 <bread>
    80002a3e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a40:	05850793          	addi	a5,a0,88
    80002a44:	40c8                	lw	a0,4(s1)
    80002a46:	893d                	andi	a0,a0,15
    80002a48:	051a                	slli	a0,a0,0x6
    80002a4a:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a4c:	04449703          	lh	a4,68(s1)
    80002a50:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a54:	04649703          	lh	a4,70(s1)
    80002a58:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a5c:	04849703          	lh	a4,72(s1)
    80002a60:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a64:	04a49703          	lh	a4,74(s1)
    80002a68:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a6c:	44f8                	lw	a4,76(s1)
    80002a6e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a70:	03400613          	li	a2,52
    80002a74:	05048593          	addi	a1,s1,80
    80002a78:	0531                	addi	a0,a0,12
    80002a7a:	ffffd097          	auipc	ra,0xffffd
    80002a7e:	75a080e7          	jalr	1882(ra) # 800001d4 <memmove>
  log_write(bp);
    80002a82:	854a                	mv	a0,s2
    80002a84:	00001097          	auipc	ra,0x1
    80002a88:	bf6080e7          	jalr	-1034(ra) # 8000367a <log_write>
  brelse(bp);
    80002a8c:	854a                	mv	a0,s2
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	968080e7          	jalr	-1688(ra) # 800023f6 <brelse>
}
    80002a96:	60e2                	ld	ra,24(sp)
    80002a98:	6442                	ld	s0,16(sp)
    80002a9a:	64a2                	ld	s1,8(sp)
    80002a9c:	6902                	ld	s2,0(sp)
    80002a9e:	6105                	addi	sp,sp,32
    80002aa0:	8082                	ret

0000000080002aa2 <idup>:
{
    80002aa2:	1101                	addi	sp,sp,-32
    80002aa4:	ec06                	sd	ra,24(sp)
    80002aa6:	e822                	sd	s0,16(sp)
    80002aa8:	e426                	sd	s1,8(sp)
    80002aaa:	1000                	addi	s0,sp,32
    80002aac:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aae:	00014517          	auipc	a0,0x14
    80002ab2:	35a50513          	addi	a0,a0,858 # 80016e08 <itable>
    80002ab6:	00003097          	auipc	ra,0x3
    80002aba:	614080e7          	jalr	1556(ra) # 800060ca <acquire>
  ip->ref++;
    80002abe:	449c                	lw	a5,8(s1)
    80002ac0:	2785                	addiw	a5,a5,1
    80002ac2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ac4:	00014517          	auipc	a0,0x14
    80002ac8:	34450513          	addi	a0,a0,836 # 80016e08 <itable>
    80002acc:	00003097          	auipc	ra,0x3
    80002ad0:	6b2080e7          	jalr	1714(ra) # 8000617e <release>
}
    80002ad4:	8526                	mv	a0,s1
    80002ad6:	60e2                	ld	ra,24(sp)
    80002ad8:	6442                	ld	s0,16(sp)
    80002ada:	64a2                	ld	s1,8(sp)
    80002adc:	6105                	addi	sp,sp,32
    80002ade:	8082                	ret

0000000080002ae0 <ilock>:
{
    80002ae0:	1101                	addi	sp,sp,-32
    80002ae2:	ec06                	sd	ra,24(sp)
    80002ae4:	e822                	sd	s0,16(sp)
    80002ae6:	e426                	sd	s1,8(sp)
    80002ae8:	e04a                	sd	s2,0(sp)
    80002aea:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002aec:	c115                	beqz	a0,80002b10 <ilock+0x30>
    80002aee:	84aa                	mv	s1,a0
    80002af0:	451c                	lw	a5,8(a0)
    80002af2:	00f05f63          	blez	a5,80002b10 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002af6:	0541                	addi	a0,a0,16
    80002af8:	00001097          	auipc	ra,0x1
    80002afc:	ca2080e7          	jalr	-862(ra) # 8000379a <acquiresleep>
  if(ip->valid == 0){
    80002b00:	40bc                	lw	a5,64(s1)
    80002b02:	cf99                	beqz	a5,80002b20 <ilock+0x40>
}
    80002b04:	60e2                	ld	ra,24(sp)
    80002b06:	6442                	ld	s0,16(sp)
    80002b08:	64a2                	ld	s1,8(sp)
    80002b0a:	6902                	ld	s2,0(sp)
    80002b0c:	6105                	addi	sp,sp,32
    80002b0e:	8082                	ret
    panic("ilock");
    80002b10:	00006517          	auipc	a0,0x6
    80002b14:	a4050513          	addi	a0,a0,-1472 # 80008550 <syscalls+0x180>
    80002b18:	00003097          	auipc	ra,0x3
    80002b1c:	076080e7          	jalr	118(ra) # 80005b8e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b20:	40dc                	lw	a5,4(s1)
    80002b22:	0047d79b          	srliw	a5,a5,0x4
    80002b26:	00014597          	auipc	a1,0x14
    80002b2a:	2da5a583          	lw	a1,730(a1) # 80016e00 <sb+0x18>
    80002b2e:	9dbd                	addw	a1,a1,a5
    80002b30:	4088                	lw	a0,0(s1)
    80002b32:	fffff097          	auipc	ra,0xfffff
    80002b36:	794080e7          	jalr	1940(ra) # 800022c6 <bread>
    80002b3a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b3c:	05850593          	addi	a1,a0,88
    80002b40:	40dc                	lw	a5,4(s1)
    80002b42:	8bbd                	andi	a5,a5,15
    80002b44:	079a                	slli	a5,a5,0x6
    80002b46:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b48:	00059783          	lh	a5,0(a1)
    80002b4c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b50:	00259783          	lh	a5,2(a1)
    80002b54:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b58:	00459783          	lh	a5,4(a1)
    80002b5c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b60:	00659783          	lh	a5,6(a1)
    80002b64:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b68:	459c                	lw	a5,8(a1)
    80002b6a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b6c:	03400613          	li	a2,52
    80002b70:	05b1                	addi	a1,a1,12
    80002b72:	05048513          	addi	a0,s1,80
    80002b76:	ffffd097          	auipc	ra,0xffffd
    80002b7a:	65e080e7          	jalr	1630(ra) # 800001d4 <memmove>
    brelse(bp);
    80002b7e:	854a                	mv	a0,s2
    80002b80:	00000097          	auipc	ra,0x0
    80002b84:	876080e7          	jalr	-1930(ra) # 800023f6 <brelse>
    ip->valid = 1;
    80002b88:	4785                	li	a5,1
    80002b8a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b8c:	04449783          	lh	a5,68(s1)
    80002b90:	fbb5                	bnez	a5,80002b04 <ilock+0x24>
      panic("ilock: no type");
    80002b92:	00006517          	auipc	a0,0x6
    80002b96:	9c650513          	addi	a0,a0,-1594 # 80008558 <syscalls+0x188>
    80002b9a:	00003097          	auipc	ra,0x3
    80002b9e:	ff4080e7          	jalr	-12(ra) # 80005b8e <panic>

0000000080002ba2 <iunlock>:
{
    80002ba2:	1101                	addi	sp,sp,-32
    80002ba4:	ec06                	sd	ra,24(sp)
    80002ba6:	e822                	sd	s0,16(sp)
    80002ba8:	e426                	sd	s1,8(sp)
    80002baa:	e04a                	sd	s2,0(sp)
    80002bac:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bae:	c905                	beqz	a0,80002bde <iunlock+0x3c>
    80002bb0:	84aa                	mv	s1,a0
    80002bb2:	01050913          	addi	s2,a0,16
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	00001097          	auipc	ra,0x1
    80002bbc:	c7c080e7          	jalr	-900(ra) # 80003834 <holdingsleep>
    80002bc0:	cd19                	beqz	a0,80002bde <iunlock+0x3c>
    80002bc2:	449c                	lw	a5,8(s1)
    80002bc4:	00f05d63          	blez	a5,80002bde <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bc8:	854a                	mv	a0,s2
    80002bca:	00001097          	auipc	ra,0x1
    80002bce:	c26080e7          	jalr	-986(ra) # 800037f0 <releasesleep>
}
    80002bd2:	60e2                	ld	ra,24(sp)
    80002bd4:	6442                	ld	s0,16(sp)
    80002bd6:	64a2                	ld	s1,8(sp)
    80002bd8:	6902                	ld	s2,0(sp)
    80002bda:	6105                	addi	sp,sp,32
    80002bdc:	8082                	ret
    panic("iunlock");
    80002bde:	00006517          	auipc	a0,0x6
    80002be2:	98a50513          	addi	a0,a0,-1654 # 80008568 <syscalls+0x198>
    80002be6:	00003097          	auipc	ra,0x3
    80002bea:	fa8080e7          	jalr	-88(ra) # 80005b8e <panic>

0000000080002bee <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bee:	7179                	addi	sp,sp,-48
    80002bf0:	f406                	sd	ra,40(sp)
    80002bf2:	f022                	sd	s0,32(sp)
    80002bf4:	ec26                	sd	s1,24(sp)
    80002bf6:	e84a                	sd	s2,16(sp)
    80002bf8:	e44e                	sd	s3,8(sp)
    80002bfa:	e052                	sd	s4,0(sp)
    80002bfc:	1800                	addi	s0,sp,48
    80002bfe:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c00:	05050493          	addi	s1,a0,80
    80002c04:	08050913          	addi	s2,a0,128
    80002c08:	a021                	j	80002c10 <itrunc+0x22>
    80002c0a:	0491                	addi	s1,s1,4
    80002c0c:	01248d63          	beq	s1,s2,80002c26 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c10:	408c                	lw	a1,0(s1)
    80002c12:	dde5                	beqz	a1,80002c0a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c14:	0009a503          	lw	a0,0(s3)
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	8f4080e7          	jalr	-1804(ra) # 8000250c <bfree>
      ip->addrs[i] = 0;
    80002c20:	0004a023          	sw	zero,0(s1)
    80002c24:	b7dd                	j	80002c0a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c26:	0809a583          	lw	a1,128(s3)
    80002c2a:	e185                	bnez	a1,80002c4a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c2c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c30:	854e                	mv	a0,s3
    80002c32:	00000097          	auipc	ra,0x0
    80002c36:	de4080e7          	jalr	-540(ra) # 80002a16 <iupdate>
}
    80002c3a:	70a2                	ld	ra,40(sp)
    80002c3c:	7402                	ld	s0,32(sp)
    80002c3e:	64e2                	ld	s1,24(sp)
    80002c40:	6942                	ld	s2,16(sp)
    80002c42:	69a2                	ld	s3,8(sp)
    80002c44:	6a02                	ld	s4,0(sp)
    80002c46:	6145                	addi	sp,sp,48
    80002c48:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c4a:	0009a503          	lw	a0,0(s3)
    80002c4e:	fffff097          	auipc	ra,0xfffff
    80002c52:	678080e7          	jalr	1656(ra) # 800022c6 <bread>
    80002c56:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c58:	05850493          	addi	s1,a0,88
    80002c5c:	45850913          	addi	s2,a0,1112
    80002c60:	a021                	j	80002c68 <itrunc+0x7a>
    80002c62:	0491                	addi	s1,s1,4
    80002c64:	01248b63          	beq	s1,s2,80002c7a <itrunc+0x8c>
      if(a[j])
    80002c68:	408c                	lw	a1,0(s1)
    80002c6a:	dde5                	beqz	a1,80002c62 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c6c:	0009a503          	lw	a0,0(s3)
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	89c080e7          	jalr	-1892(ra) # 8000250c <bfree>
    80002c78:	b7ed                	j	80002c62 <itrunc+0x74>
    brelse(bp);
    80002c7a:	8552                	mv	a0,s4
    80002c7c:	fffff097          	auipc	ra,0xfffff
    80002c80:	77a080e7          	jalr	1914(ra) # 800023f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c84:	0809a583          	lw	a1,128(s3)
    80002c88:	0009a503          	lw	a0,0(s3)
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	880080e7          	jalr	-1920(ra) # 8000250c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c94:	0809a023          	sw	zero,128(s3)
    80002c98:	bf51                	j	80002c2c <itrunc+0x3e>

0000000080002c9a <iput>:
{
    80002c9a:	1101                	addi	sp,sp,-32
    80002c9c:	ec06                	sd	ra,24(sp)
    80002c9e:	e822                	sd	s0,16(sp)
    80002ca0:	e426                	sd	s1,8(sp)
    80002ca2:	e04a                	sd	s2,0(sp)
    80002ca4:	1000                	addi	s0,sp,32
    80002ca6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca8:	00014517          	auipc	a0,0x14
    80002cac:	16050513          	addi	a0,a0,352 # 80016e08 <itable>
    80002cb0:	00003097          	auipc	ra,0x3
    80002cb4:	41a080e7          	jalr	1050(ra) # 800060ca <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cb8:	4498                	lw	a4,8(s1)
    80002cba:	4785                	li	a5,1
    80002cbc:	02f70363          	beq	a4,a5,80002ce2 <iput+0x48>
  ip->ref--;
    80002cc0:	449c                	lw	a5,8(s1)
    80002cc2:	37fd                	addiw	a5,a5,-1
    80002cc4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cc6:	00014517          	auipc	a0,0x14
    80002cca:	14250513          	addi	a0,a0,322 # 80016e08 <itable>
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	4b0080e7          	jalr	1200(ra) # 8000617e <release>
}
    80002cd6:	60e2                	ld	ra,24(sp)
    80002cd8:	6442                	ld	s0,16(sp)
    80002cda:	64a2                	ld	s1,8(sp)
    80002cdc:	6902                	ld	s2,0(sp)
    80002cde:	6105                	addi	sp,sp,32
    80002ce0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ce2:	40bc                	lw	a5,64(s1)
    80002ce4:	dff1                	beqz	a5,80002cc0 <iput+0x26>
    80002ce6:	04a49783          	lh	a5,74(s1)
    80002cea:	fbf9                	bnez	a5,80002cc0 <iput+0x26>
    acquiresleep(&ip->lock);
    80002cec:	01048913          	addi	s2,s1,16
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	00001097          	auipc	ra,0x1
    80002cf6:	aa8080e7          	jalr	-1368(ra) # 8000379a <acquiresleep>
    release(&itable.lock);
    80002cfa:	00014517          	auipc	a0,0x14
    80002cfe:	10e50513          	addi	a0,a0,270 # 80016e08 <itable>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	47c080e7          	jalr	1148(ra) # 8000617e <release>
    itrunc(ip);
    80002d0a:	8526                	mv	a0,s1
    80002d0c:	00000097          	auipc	ra,0x0
    80002d10:	ee2080e7          	jalr	-286(ra) # 80002bee <itrunc>
    ip->type = 0;
    80002d14:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d18:	8526                	mv	a0,s1
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	cfc080e7          	jalr	-772(ra) # 80002a16 <iupdate>
    ip->valid = 0;
    80002d22:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d26:	854a                	mv	a0,s2
    80002d28:	00001097          	auipc	ra,0x1
    80002d2c:	ac8080e7          	jalr	-1336(ra) # 800037f0 <releasesleep>
    acquire(&itable.lock);
    80002d30:	00014517          	auipc	a0,0x14
    80002d34:	0d850513          	addi	a0,a0,216 # 80016e08 <itable>
    80002d38:	00003097          	auipc	ra,0x3
    80002d3c:	392080e7          	jalr	914(ra) # 800060ca <acquire>
    80002d40:	b741                	j	80002cc0 <iput+0x26>

0000000080002d42 <iunlockput>:
{
    80002d42:	1101                	addi	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	e426                	sd	s1,8(sp)
    80002d4a:	1000                	addi	s0,sp,32
    80002d4c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	e54080e7          	jalr	-428(ra) # 80002ba2 <iunlock>
  iput(ip);
    80002d56:	8526                	mv	a0,s1
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	f42080e7          	jalr	-190(ra) # 80002c9a <iput>
}
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret

0000000080002d6a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d6a:	1141                	addi	sp,sp,-16
    80002d6c:	e422                	sd	s0,8(sp)
    80002d6e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d70:	411c                	lw	a5,0(a0)
    80002d72:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d74:	415c                	lw	a5,4(a0)
    80002d76:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d78:	04451783          	lh	a5,68(a0)
    80002d7c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d80:	04a51783          	lh	a5,74(a0)
    80002d84:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d88:	04c56783          	lwu	a5,76(a0)
    80002d8c:	e99c                	sd	a5,16(a1)
}
    80002d8e:	6422                	ld	s0,8(sp)
    80002d90:	0141                	addi	sp,sp,16
    80002d92:	8082                	ret

0000000080002d94 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d94:	457c                	lw	a5,76(a0)
    80002d96:	0ed7e963          	bltu	a5,a3,80002e88 <readi+0xf4>
{
    80002d9a:	7159                	addi	sp,sp,-112
    80002d9c:	f486                	sd	ra,104(sp)
    80002d9e:	f0a2                	sd	s0,96(sp)
    80002da0:	eca6                	sd	s1,88(sp)
    80002da2:	e8ca                	sd	s2,80(sp)
    80002da4:	e4ce                	sd	s3,72(sp)
    80002da6:	e0d2                	sd	s4,64(sp)
    80002da8:	fc56                	sd	s5,56(sp)
    80002daa:	f85a                	sd	s6,48(sp)
    80002dac:	f45e                	sd	s7,40(sp)
    80002dae:	f062                	sd	s8,32(sp)
    80002db0:	ec66                	sd	s9,24(sp)
    80002db2:	e86a                	sd	s10,16(sp)
    80002db4:	e46e                	sd	s11,8(sp)
    80002db6:	1880                	addi	s0,sp,112
    80002db8:	8b2a                	mv	s6,a0
    80002dba:	8bae                	mv	s7,a1
    80002dbc:	8a32                	mv	s4,a2
    80002dbe:	84b6                	mv	s1,a3
    80002dc0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dc2:	9f35                	addw	a4,a4,a3
    return 0;
    80002dc4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dc6:	0ad76063          	bltu	a4,a3,80002e66 <readi+0xd2>
  if(off + n > ip->size)
    80002dca:	00e7f463          	bgeu	a5,a4,80002dd2 <readi+0x3e>
    n = ip->size - off;
    80002dce:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dd2:	0a0a8963          	beqz	s5,80002e84 <readi+0xf0>
    80002dd6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dd8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ddc:	5c7d                	li	s8,-1
    80002dde:	a82d                	j	80002e18 <readi+0x84>
    80002de0:	020d1d93          	slli	s11,s10,0x20
    80002de4:	020ddd93          	srli	s11,s11,0x20
    80002de8:	05890793          	addi	a5,s2,88
    80002dec:	86ee                	mv	a3,s11
    80002dee:	963e                	add	a2,a2,a5
    80002df0:	85d2                	mv	a1,s4
    80002df2:	855e                	mv	a0,s7
    80002df4:	fffff097          	auipc	ra,0xfffff
    80002df8:	b0e080e7          	jalr	-1266(ra) # 80001902 <either_copyout>
    80002dfc:	05850d63          	beq	a0,s8,80002e56 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e00:	854a                	mv	a0,s2
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	5f4080e7          	jalr	1524(ra) # 800023f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e0a:	013d09bb          	addw	s3,s10,s3
    80002e0e:	009d04bb          	addw	s1,s10,s1
    80002e12:	9a6e                	add	s4,s4,s11
    80002e14:	0559f763          	bgeu	s3,s5,80002e62 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e18:	00a4d59b          	srliw	a1,s1,0xa
    80002e1c:	855a                	mv	a0,s6
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	8a2080e7          	jalr	-1886(ra) # 800026c0 <bmap>
    80002e26:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e2a:	cd85                	beqz	a1,80002e62 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e2c:	000b2503          	lw	a0,0(s6)
    80002e30:	fffff097          	auipc	ra,0xfffff
    80002e34:	496080e7          	jalr	1174(ra) # 800022c6 <bread>
    80002e38:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e3a:	3ff4f613          	andi	a2,s1,1023
    80002e3e:	40cc87bb          	subw	a5,s9,a2
    80002e42:	413a873b          	subw	a4,s5,s3
    80002e46:	8d3e                	mv	s10,a5
    80002e48:	2781                	sext.w	a5,a5
    80002e4a:	0007069b          	sext.w	a3,a4
    80002e4e:	f8f6f9e3          	bgeu	a3,a5,80002de0 <readi+0x4c>
    80002e52:	8d3a                	mv	s10,a4
    80002e54:	b771                	j	80002de0 <readi+0x4c>
      brelse(bp);
    80002e56:	854a                	mv	a0,s2
    80002e58:	fffff097          	auipc	ra,0xfffff
    80002e5c:	59e080e7          	jalr	1438(ra) # 800023f6 <brelse>
      tot = -1;
    80002e60:	59fd                	li	s3,-1
  }
  return tot;
    80002e62:	0009851b          	sext.w	a0,s3
}
    80002e66:	70a6                	ld	ra,104(sp)
    80002e68:	7406                	ld	s0,96(sp)
    80002e6a:	64e6                	ld	s1,88(sp)
    80002e6c:	6946                	ld	s2,80(sp)
    80002e6e:	69a6                	ld	s3,72(sp)
    80002e70:	6a06                	ld	s4,64(sp)
    80002e72:	7ae2                	ld	s5,56(sp)
    80002e74:	7b42                	ld	s6,48(sp)
    80002e76:	7ba2                	ld	s7,40(sp)
    80002e78:	7c02                	ld	s8,32(sp)
    80002e7a:	6ce2                	ld	s9,24(sp)
    80002e7c:	6d42                	ld	s10,16(sp)
    80002e7e:	6da2                	ld	s11,8(sp)
    80002e80:	6165                	addi	sp,sp,112
    80002e82:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e84:	89d6                	mv	s3,s5
    80002e86:	bff1                	j	80002e62 <readi+0xce>
    return 0;
    80002e88:	4501                	li	a0,0
}
    80002e8a:	8082                	ret

0000000080002e8c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8c:	457c                	lw	a5,76(a0)
    80002e8e:	10d7e863          	bltu	a5,a3,80002f9e <writei+0x112>
{
    80002e92:	7159                	addi	sp,sp,-112
    80002e94:	f486                	sd	ra,104(sp)
    80002e96:	f0a2                	sd	s0,96(sp)
    80002e98:	eca6                	sd	s1,88(sp)
    80002e9a:	e8ca                	sd	s2,80(sp)
    80002e9c:	e4ce                	sd	s3,72(sp)
    80002e9e:	e0d2                	sd	s4,64(sp)
    80002ea0:	fc56                	sd	s5,56(sp)
    80002ea2:	f85a                	sd	s6,48(sp)
    80002ea4:	f45e                	sd	s7,40(sp)
    80002ea6:	f062                	sd	s8,32(sp)
    80002ea8:	ec66                	sd	s9,24(sp)
    80002eaa:	e86a                	sd	s10,16(sp)
    80002eac:	e46e                	sd	s11,8(sp)
    80002eae:	1880                	addi	s0,sp,112
    80002eb0:	8aaa                	mv	s5,a0
    80002eb2:	8bae                	mv	s7,a1
    80002eb4:	8a32                	mv	s4,a2
    80002eb6:	8936                	mv	s2,a3
    80002eb8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eba:	00e687bb          	addw	a5,a3,a4
    80002ebe:	0ed7e263          	bltu	a5,a3,80002fa2 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ec2:	00043737          	lui	a4,0x43
    80002ec6:	0ef76063          	bltu	a4,a5,80002fa6 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002eca:	0c0b0863          	beqz	s6,80002f9a <writei+0x10e>
    80002ece:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ed0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ed4:	5c7d                	li	s8,-1
    80002ed6:	a091                	j	80002f1a <writei+0x8e>
    80002ed8:	020d1d93          	slli	s11,s10,0x20
    80002edc:	020ddd93          	srli	s11,s11,0x20
    80002ee0:	05848793          	addi	a5,s1,88
    80002ee4:	86ee                	mv	a3,s11
    80002ee6:	8652                	mv	a2,s4
    80002ee8:	85de                	mv	a1,s7
    80002eea:	953e                	add	a0,a0,a5
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	a6c080e7          	jalr	-1428(ra) # 80001958 <either_copyin>
    80002ef4:	07850263          	beq	a0,s8,80002f58 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ef8:	8526                	mv	a0,s1
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	780080e7          	jalr	1920(ra) # 8000367a <log_write>
    brelse(bp);
    80002f02:	8526                	mv	a0,s1
    80002f04:	fffff097          	auipc	ra,0xfffff
    80002f08:	4f2080e7          	jalr	1266(ra) # 800023f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f0c:	013d09bb          	addw	s3,s10,s3
    80002f10:	012d093b          	addw	s2,s10,s2
    80002f14:	9a6e                	add	s4,s4,s11
    80002f16:	0569f663          	bgeu	s3,s6,80002f62 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f1a:	00a9559b          	srliw	a1,s2,0xa
    80002f1e:	8556                	mv	a0,s5
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	7a0080e7          	jalr	1952(ra) # 800026c0 <bmap>
    80002f28:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f2c:	c99d                	beqz	a1,80002f62 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f2e:	000aa503          	lw	a0,0(s5)
    80002f32:	fffff097          	auipc	ra,0xfffff
    80002f36:	394080e7          	jalr	916(ra) # 800022c6 <bread>
    80002f3a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3c:	3ff97513          	andi	a0,s2,1023
    80002f40:	40ac87bb          	subw	a5,s9,a0
    80002f44:	413b073b          	subw	a4,s6,s3
    80002f48:	8d3e                	mv	s10,a5
    80002f4a:	2781                	sext.w	a5,a5
    80002f4c:	0007069b          	sext.w	a3,a4
    80002f50:	f8f6f4e3          	bgeu	a3,a5,80002ed8 <writei+0x4c>
    80002f54:	8d3a                	mv	s10,a4
    80002f56:	b749                	j	80002ed8 <writei+0x4c>
      brelse(bp);
    80002f58:	8526                	mv	a0,s1
    80002f5a:	fffff097          	auipc	ra,0xfffff
    80002f5e:	49c080e7          	jalr	1180(ra) # 800023f6 <brelse>
  }

  if(off > ip->size)
    80002f62:	04caa783          	lw	a5,76(s5)
    80002f66:	0127f463          	bgeu	a5,s2,80002f6e <writei+0xe2>
    ip->size = off;
    80002f6a:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f6e:	8556                	mv	a0,s5
    80002f70:	00000097          	auipc	ra,0x0
    80002f74:	aa6080e7          	jalr	-1370(ra) # 80002a16 <iupdate>

  return tot;
    80002f78:	0009851b          	sext.w	a0,s3
}
    80002f7c:	70a6                	ld	ra,104(sp)
    80002f7e:	7406                	ld	s0,96(sp)
    80002f80:	64e6                	ld	s1,88(sp)
    80002f82:	6946                	ld	s2,80(sp)
    80002f84:	69a6                	ld	s3,72(sp)
    80002f86:	6a06                	ld	s4,64(sp)
    80002f88:	7ae2                	ld	s5,56(sp)
    80002f8a:	7b42                	ld	s6,48(sp)
    80002f8c:	7ba2                	ld	s7,40(sp)
    80002f8e:	7c02                	ld	s8,32(sp)
    80002f90:	6ce2                	ld	s9,24(sp)
    80002f92:	6d42                	ld	s10,16(sp)
    80002f94:	6da2                	ld	s11,8(sp)
    80002f96:	6165                	addi	sp,sp,112
    80002f98:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f9a:	89da                	mv	s3,s6
    80002f9c:	bfc9                	j	80002f6e <writei+0xe2>
    return -1;
    80002f9e:	557d                	li	a0,-1
}
    80002fa0:	8082                	ret
    return -1;
    80002fa2:	557d                	li	a0,-1
    80002fa4:	bfe1                	j	80002f7c <writei+0xf0>
    return -1;
    80002fa6:	557d                	li	a0,-1
    80002fa8:	bfd1                	j	80002f7c <writei+0xf0>

0000000080002faa <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002faa:	1141                	addi	sp,sp,-16
    80002fac:	e406                	sd	ra,8(sp)
    80002fae:	e022                	sd	s0,0(sp)
    80002fb0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fb2:	4639                	li	a2,14
    80002fb4:	ffffd097          	auipc	ra,0xffffd
    80002fb8:	294080e7          	jalr	660(ra) # 80000248 <strncmp>
}
    80002fbc:	60a2                	ld	ra,8(sp)
    80002fbe:	6402                	ld	s0,0(sp)
    80002fc0:	0141                	addi	sp,sp,16
    80002fc2:	8082                	ret

0000000080002fc4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fc4:	7139                	addi	sp,sp,-64
    80002fc6:	fc06                	sd	ra,56(sp)
    80002fc8:	f822                	sd	s0,48(sp)
    80002fca:	f426                	sd	s1,40(sp)
    80002fcc:	f04a                	sd	s2,32(sp)
    80002fce:	ec4e                	sd	s3,24(sp)
    80002fd0:	e852                	sd	s4,16(sp)
    80002fd2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fd4:	04451703          	lh	a4,68(a0)
    80002fd8:	4785                	li	a5,1
    80002fda:	00f71a63          	bne	a4,a5,80002fee <dirlookup+0x2a>
    80002fde:	892a                	mv	s2,a0
    80002fe0:	89ae                	mv	s3,a1
    80002fe2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe4:	457c                	lw	a5,76(a0)
    80002fe6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fe8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fea:	e79d                	bnez	a5,80003018 <dirlookup+0x54>
    80002fec:	a8a5                	j	80003064 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fee:	00005517          	auipc	a0,0x5
    80002ff2:	58250513          	addi	a0,a0,1410 # 80008570 <syscalls+0x1a0>
    80002ff6:	00003097          	auipc	ra,0x3
    80002ffa:	b98080e7          	jalr	-1128(ra) # 80005b8e <panic>
      panic("dirlookup read");
    80002ffe:	00005517          	auipc	a0,0x5
    80003002:	58a50513          	addi	a0,a0,1418 # 80008588 <syscalls+0x1b8>
    80003006:	00003097          	auipc	ra,0x3
    8000300a:	b88080e7          	jalr	-1144(ra) # 80005b8e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000300e:	24c1                	addiw	s1,s1,16
    80003010:	04c92783          	lw	a5,76(s2)
    80003014:	04f4f763          	bgeu	s1,a5,80003062 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003018:	4741                	li	a4,16
    8000301a:	86a6                	mv	a3,s1
    8000301c:	fc040613          	addi	a2,s0,-64
    80003020:	4581                	li	a1,0
    80003022:	854a                	mv	a0,s2
    80003024:	00000097          	auipc	ra,0x0
    80003028:	d70080e7          	jalr	-656(ra) # 80002d94 <readi>
    8000302c:	47c1                	li	a5,16
    8000302e:	fcf518e3          	bne	a0,a5,80002ffe <dirlookup+0x3a>
    if(de.inum == 0)
    80003032:	fc045783          	lhu	a5,-64(s0)
    80003036:	dfe1                	beqz	a5,8000300e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003038:	fc240593          	addi	a1,s0,-62
    8000303c:	854e                	mv	a0,s3
    8000303e:	00000097          	auipc	ra,0x0
    80003042:	f6c080e7          	jalr	-148(ra) # 80002faa <namecmp>
    80003046:	f561                	bnez	a0,8000300e <dirlookup+0x4a>
      if(poff)
    80003048:	000a0463          	beqz	s4,80003050 <dirlookup+0x8c>
        *poff = off;
    8000304c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003050:	fc045583          	lhu	a1,-64(s0)
    80003054:	00092503          	lw	a0,0(s2)
    80003058:	fffff097          	auipc	ra,0xfffff
    8000305c:	750080e7          	jalr	1872(ra) # 800027a8 <iget>
    80003060:	a011                	j	80003064 <dirlookup+0xa0>
  return 0;
    80003062:	4501                	li	a0,0
}
    80003064:	70e2                	ld	ra,56(sp)
    80003066:	7442                	ld	s0,48(sp)
    80003068:	74a2                	ld	s1,40(sp)
    8000306a:	7902                	ld	s2,32(sp)
    8000306c:	69e2                	ld	s3,24(sp)
    8000306e:	6a42                	ld	s4,16(sp)
    80003070:	6121                	addi	sp,sp,64
    80003072:	8082                	ret

0000000080003074 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003074:	711d                	addi	sp,sp,-96
    80003076:	ec86                	sd	ra,88(sp)
    80003078:	e8a2                	sd	s0,80(sp)
    8000307a:	e4a6                	sd	s1,72(sp)
    8000307c:	e0ca                	sd	s2,64(sp)
    8000307e:	fc4e                	sd	s3,56(sp)
    80003080:	f852                	sd	s4,48(sp)
    80003082:	f456                	sd	s5,40(sp)
    80003084:	f05a                	sd	s6,32(sp)
    80003086:	ec5e                	sd	s7,24(sp)
    80003088:	e862                	sd	s8,16(sp)
    8000308a:	e466                	sd	s9,8(sp)
    8000308c:	1080                	addi	s0,sp,96
    8000308e:	84aa                	mv	s1,a0
    80003090:	8aae                	mv	s5,a1
    80003092:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003094:	00054703          	lbu	a4,0(a0)
    80003098:	02f00793          	li	a5,47
    8000309c:	02f70363          	beq	a4,a5,800030c2 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	db2080e7          	jalr	-590(ra) # 80000e52 <myproc>
    800030a8:	15053503          	ld	a0,336(a0)
    800030ac:	00000097          	auipc	ra,0x0
    800030b0:	9f6080e7          	jalr	-1546(ra) # 80002aa2 <idup>
    800030b4:	89aa                	mv	s3,a0
  while(*path == '/')
    800030b6:	02f00913          	li	s2,47
  len = path - s;
    800030ba:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800030bc:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030be:	4b85                	li	s7,1
    800030c0:	a865                	j	80003178 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030c2:	4585                	li	a1,1
    800030c4:	4505                	li	a0,1
    800030c6:	fffff097          	auipc	ra,0xfffff
    800030ca:	6e2080e7          	jalr	1762(ra) # 800027a8 <iget>
    800030ce:	89aa                	mv	s3,a0
    800030d0:	b7dd                	j	800030b6 <namex+0x42>
      iunlockput(ip);
    800030d2:	854e                	mv	a0,s3
    800030d4:	00000097          	auipc	ra,0x0
    800030d8:	c6e080e7          	jalr	-914(ra) # 80002d42 <iunlockput>
      return 0;
    800030dc:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030de:	854e                	mv	a0,s3
    800030e0:	60e6                	ld	ra,88(sp)
    800030e2:	6446                	ld	s0,80(sp)
    800030e4:	64a6                	ld	s1,72(sp)
    800030e6:	6906                	ld	s2,64(sp)
    800030e8:	79e2                	ld	s3,56(sp)
    800030ea:	7a42                	ld	s4,48(sp)
    800030ec:	7aa2                	ld	s5,40(sp)
    800030ee:	7b02                	ld	s6,32(sp)
    800030f0:	6be2                	ld	s7,24(sp)
    800030f2:	6c42                	ld	s8,16(sp)
    800030f4:	6ca2                	ld	s9,8(sp)
    800030f6:	6125                	addi	sp,sp,96
    800030f8:	8082                	ret
      iunlock(ip);
    800030fa:	854e                	mv	a0,s3
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	aa6080e7          	jalr	-1370(ra) # 80002ba2 <iunlock>
      return ip;
    80003104:	bfe9                	j	800030de <namex+0x6a>
      iunlockput(ip);
    80003106:	854e                	mv	a0,s3
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	c3a080e7          	jalr	-966(ra) # 80002d42 <iunlockput>
      return 0;
    80003110:	89e6                	mv	s3,s9
    80003112:	b7f1                	j	800030de <namex+0x6a>
  len = path - s;
    80003114:	40b48633          	sub	a2,s1,a1
    80003118:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000311c:	099c5463          	bge	s8,s9,800031a4 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003120:	4639                	li	a2,14
    80003122:	8552                	mv	a0,s4
    80003124:	ffffd097          	auipc	ra,0xffffd
    80003128:	0b0080e7          	jalr	176(ra) # 800001d4 <memmove>
  while(*path == '/')
    8000312c:	0004c783          	lbu	a5,0(s1)
    80003130:	01279763          	bne	a5,s2,8000313e <namex+0xca>
    path++;
    80003134:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003136:	0004c783          	lbu	a5,0(s1)
    8000313a:	ff278de3          	beq	a5,s2,80003134 <namex+0xc0>
    ilock(ip);
    8000313e:	854e                	mv	a0,s3
    80003140:	00000097          	auipc	ra,0x0
    80003144:	9a0080e7          	jalr	-1632(ra) # 80002ae0 <ilock>
    if(ip->type != T_DIR){
    80003148:	04499783          	lh	a5,68(s3)
    8000314c:	f97793e3          	bne	a5,s7,800030d2 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003150:	000a8563          	beqz	s5,8000315a <namex+0xe6>
    80003154:	0004c783          	lbu	a5,0(s1)
    80003158:	d3cd                	beqz	a5,800030fa <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000315a:	865a                	mv	a2,s6
    8000315c:	85d2                	mv	a1,s4
    8000315e:	854e                	mv	a0,s3
    80003160:	00000097          	auipc	ra,0x0
    80003164:	e64080e7          	jalr	-412(ra) # 80002fc4 <dirlookup>
    80003168:	8caa                	mv	s9,a0
    8000316a:	dd51                	beqz	a0,80003106 <namex+0x92>
    iunlockput(ip);
    8000316c:	854e                	mv	a0,s3
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	bd4080e7          	jalr	-1068(ra) # 80002d42 <iunlockput>
    ip = next;
    80003176:	89e6                	mv	s3,s9
  while(*path == '/')
    80003178:	0004c783          	lbu	a5,0(s1)
    8000317c:	05279763          	bne	a5,s2,800031ca <namex+0x156>
    path++;
    80003180:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003182:	0004c783          	lbu	a5,0(s1)
    80003186:	ff278de3          	beq	a5,s2,80003180 <namex+0x10c>
  if(*path == 0)
    8000318a:	c79d                	beqz	a5,800031b8 <namex+0x144>
    path++;
    8000318c:	85a6                	mv	a1,s1
  len = path - s;
    8000318e:	8cda                	mv	s9,s6
    80003190:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003192:	01278963          	beq	a5,s2,800031a4 <namex+0x130>
    80003196:	dfbd                	beqz	a5,80003114 <namex+0xa0>
    path++;
    80003198:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000319a:	0004c783          	lbu	a5,0(s1)
    8000319e:	ff279ce3          	bne	a5,s2,80003196 <namex+0x122>
    800031a2:	bf8d                	j	80003114 <namex+0xa0>
    memmove(name, s, len);
    800031a4:	2601                	sext.w	a2,a2
    800031a6:	8552                	mv	a0,s4
    800031a8:	ffffd097          	auipc	ra,0xffffd
    800031ac:	02c080e7          	jalr	44(ra) # 800001d4 <memmove>
    name[len] = 0;
    800031b0:	9cd2                	add	s9,s9,s4
    800031b2:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031b6:	bf9d                	j	8000312c <namex+0xb8>
  if(nameiparent){
    800031b8:	f20a83e3          	beqz	s5,800030de <namex+0x6a>
    iput(ip);
    800031bc:	854e                	mv	a0,s3
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	adc080e7          	jalr	-1316(ra) # 80002c9a <iput>
    return 0;
    800031c6:	4981                	li	s3,0
    800031c8:	bf19                	j	800030de <namex+0x6a>
  if(*path == 0)
    800031ca:	d7fd                	beqz	a5,800031b8 <namex+0x144>
  while(*path != '/' && *path != 0)
    800031cc:	0004c783          	lbu	a5,0(s1)
    800031d0:	85a6                	mv	a1,s1
    800031d2:	b7d1                	j	80003196 <namex+0x122>

00000000800031d4 <dirlink>:
{
    800031d4:	7139                	addi	sp,sp,-64
    800031d6:	fc06                	sd	ra,56(sp)
    800031d8:	f822                	sd	s0,48(sp)
    800031da:	f426                	sd	s1,40(sp)
    800031dc:	f04a                	sd	s2,32(sp)
    800031de:	ec4e                	sd	s3,24(sp)
    800031e0:	e852                	sd	s4,16(sp)
    800031e2:	0080                	addi	s0,sp,64
    800031e4:	892a                	mv	s2,a0
    800031e6:	8a2e                	mv	s4,a1
    800031e8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031ea:	4601                	li	a2,0
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	dd8080e7          	jalr	-552(ra) # 80002fc4 <dirlookup>
    800031f4:	e93d                	bnez	a0,8000326a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f6:	04c92483          	lw	s1,76(s2)
    800031fa:	c49d                	beqz	s1,80003228 <dirlink+0x54>
    800031fc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031fe:	4741                	li	a4,16
    80003200:	86a6                	mv	a3,s1
    80003202:	fc040613          	addi	a2,s0,-64
    80003206:	4581                	li	a1,0
    80003208:	854a                	mv	a0,s2
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	b8a080e7          	jalr	-1142(ra) # 80002d94 <readi>
    80003212:	47c1                	li	a5,16
    80003214:	06f51163          	bne	a0,a5,80003276 <dirlink+0xa2>
    if(de.inum == 0)
    80003218:	fc045783          	lhu	a5,-64(s0)
    8000321c:	c791                	beqz	a5,80003228 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321e:	24c1                	addiw	s1,s1,16
    80003220:	04c92783          	lw	a5,76(s2)
    80003224:	fcf4ede3          	bltu	s1,a5,800031fe <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003228:	4639                	li	a2,14
    8000322a:	85d2                	mv	a1,s4
    8000322c:	fc240513          	addi	a0,s0,-62
    80003230:	ffffd097          	auipc	ra,0xffffd
    80003234:	054080e7          	jalr	84(ra) # 80000284 <strncpy>
  de.inum = inum;
    80003238:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000323c:	4741                	li	a4,16
    8000323e:	86a6                	mv	a3,s1
    80003240:	fc040613          	addi	a2,s0,-64
    80003244:	4581                	li	a1,0
    80003246:	854a                	mv	a0,s2
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	c44080e7          	jalr	-956(ra) # 80002e8c <writei>
    80003250:	1541                	addi	a0,a0,-16
    80003252:	00a03533          	snez	a0,a0
    80003256:	40a00533          	neg	a0,a0
}
    8000325a:	70e2                	ld	ra,56(sp)
    8000325c:	7442                	ld	s0,48(sp)
    8000325e:	74a2                	ld	s1,40(sp)
    80003260:	7902                	ld	s2,32(sp)
    80003262:	69e2                	ld	s3,24(sp)
    80003264:	6a42                	ld	s4,16(sp)
    80003266:	6121                	addi	sp,sp,64
    80003268:	8082                	ret
    iput(ip);
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	a30080e7          	jalr	-1488(ra) # 80002c9a <iput>
    return -1;
    80003272:	557d                	li	a0,-1
    80003274:	b7dd                	j	8000325a <dirlink+0x86>
      panic("dirlink read");
    80003276:	00005517          	auipc	a0,0x5
    8000327a:	32250513          	addi	a0,a0,802 # 80008598 <syscalls+0x1c8>
    8000327e:	00003097          	auipc	ra,0x3
    80003282:	910080e7          	jalr	-1776(ra) # 80005b8e <panic>

0000000080003286 <namei>:

struct inode*
namei(char *path)
{
    80003286:	1101                	addi	sp,sp,-32
    80003288:	ec06                	sd	ra,24(sp)
    8000328a:	e822                	sd	s0,16(sp)
    8000328c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000328e:	fe040613          	addi	a2,s0,-32
    80003292:	4581                	li	a1,0
    80003294:	00000097          	auipc	ra,0x0
    80003298:	de0080e7          	jalr	-544(ra) # 80003074 <namex>
}
    8000329c:	60e2                	ld	ra,24(sp)
    8000329e:	6442                	ld	s0,16(sp)
    800032a0:	6105                	addi	sp,sp,32
    800032a2:	8082                	ret

00000000800032a4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032a4:	1141                	addi	sp,sp,-16
    800032a6:	e406                	sd	ra,8(sp)
    800032a8:	e022                	sd	s0,0(sp)
    800032aa:	0800                	addi	s0,sp,16
    800032ac:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032ae:	4585                	li	a1,1
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	dc4080e7          	jalr	-572(ra) # 80003074 <namex>
}
    800032b8:	60a2                	ld	ra,8(sp)
    800032ba:	6402                	ld	s0,0(sp)
    800032bc:	0141                	addi	sp,sp,16
    800032be:	8082                	ret

00000000800032c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032c0:	1101                	addi	sp,sp,-32
    800032c2:	ec06                	sd	ra,24(sp)
    800032c4:	e822                	sd	s0,16(sp)
    800032c6:	e426                	sd	s1,8(sp)
    800032c8:	e04a                	sd	s2,0(sp)
    800032ca:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032cc:	00015917          	auipc	s2,0x15
    800032d0:	5e490913          	addi	s2,s2,1508 # 800188b0 <log>
    800032d4:	01892583          	lw	a1,24(s2)
    800032d8:	02892503          	lw	a0,40(s2)
    800032dc:	fffff097          	auipc	ra,0xfffff
    800032e0:	fea080e7          	jalr	-22(ra) # 800022c6 <bread>
    800032e4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032e6:	02c92683          	lw	a3,44(s2)
    800032ea:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032ec:	02d05763          	blez	a3,8000331a <write_head+0x5a>
    800032f0:	00015797          	auipc	a5,0x15
    800032f4:	5f078793          	addi	a5,a5,1520 # 800188e0 <log+0x30>
    800032f8:	05c50713          	addi	a4,a0,92
    800032fc:	36fd                	addiw	a3,a3,-1
    800032fe:	1682                	slli	a3,a3,0x20
    80003300:	9281                	srli	a3,a3,0x20
    80003302:	068a                	slli	a3,a3,0x2
    80003304:	00015617          	auipc	a2,0x15
    80003308:	5e060613          	addi	a2,a2,1504 # 800188e4 <log+0x34>
    8000330c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000330e:	4390                	lw	a2,0(a5)
    80003310:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003312:	0791                	addi	a5,a5,4
    80003314:	0711                	addi	a4,a4,4
    80003316:	fed79ce3          	bne	a5,a3,8000330e <write_head+0x4e>
  }
  bwrite(buf);
    8000331a:	8526                	mv	a0,s1
    8000331c:	fffff097          	auipc	ra,0xfffff
    80003320:	09c080e7          	jalr	156(ra) # 800023b8 <bwrite>
  brelse(buf);
    80003324:	8526                	mv	a0,s1
    80003326:	fffff097          	auipc	ra,0xfffff
    8000332a:	0d0080e7          	jalr	208(ra) # 800023f6 <brelse>
}
    8000332e:	60e2                	ld	ra,24(sp)
    80003330:	6442                	ld	s0,16(sp)
    80003332:	64a2                	ld	s1,8(sp)
    80003334:	6902                	ld	s2,0(sp)
    80003336:	6105                	addi	sp,sp,32
    80003338:	8082                	ret

000000008000333a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000333a:	00015797          	auipc	a5,0x15
    8000333e:	5a27a783          	lw	a5,1442(a5) # 800188dc <log+0x2c>
    80003342:	0af05d63          	blez	a5,800033fc <install_trans+0xc2>
{
    80003346:	7139                	addi	sp,sp,-64
    80003348:	fc06                	sd	ra,56(sp)
    8000334a:	f822                	sd	s0,48(sp)
    8000334c:	f426                	sd	s1,40(sp)
    8000334e:	f04a                	sd	s2,32(sp)
    80003350:	ec4e                	sd	s3,24(sp)
    80003352:	e852                	sd	s4,16(sp)
    80003354:	e456                	sd	s5,8(sp)
    80003356:	e05a                	sd	s6,0(sp)
    80003358:	0080                	addi	s0,sp,64
    8000335a:	8b2a                	mv	s6,a0
    8000335c:	00015a97          	auipc	s5,0x15
    80003360:	584a8a93          	addi	s5,s5,1412 # 800188e0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003364:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003366:	00015997          	auipc	s3,0x15
    8000336a:	54a98993          	addi	s3,s3,1354 # 800188b0 <log>
    8000336e:	a00d                	j	80003390 <install_trans+0x56>
    brelse(lbuf);
    80003370:	854a                	mv	a0,s2
    80003372:	fffff097          	auipc	ra,0xfffff
    80003376:	084080e7          	jalr	132(ra) # 800023f6 <brelse>
    brelse(dbuf);
    8000337a:	8526                	mv	a0,s1
    8000337c:	fffff097          	auipc	ra,0xfffff
    80003380:	07a080e7          	jalr	122(ra) # 800023f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003384:	2a05                	addiw	s4,s4,1
    80003386:	0a91                	addi	s5,s5,4
    80003388:	02c9a783          	lw	a5,44(s3)
    8000338c:	04fa5e63          	bge	s4,a5,800033e8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003390:	0189a583          	lw	a1,24(s3)
    80003394:	014585bb          	addw	a1,a1,s4
    80003398:	2585                	addiw	a1,a1,1
    8000339a:	0289a503          	lw	a0,40(s3)
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	f28080e7          	jalr	-216(ra) # 800022c6 <bread>
    800033a6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033a8:	000aa583          	lw	a1,0(s5)
    800033ac:	0289a503          	lw	a0,40(s3)
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	f16080e7          	jalr	-234(ra) # 800022c6 <bread>
    800033b8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ba:	40000613          	li	a2,1024
    800033be:	05890593          	addi	a1,s2,88
    800033c2:	05850513          	addi	a0,a0,88
    800033c6:	ffffd097          	auipc	ra,0xffffd
    800033ca:	e0e080e7          	jalr	-498(ra) # 800001d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033ce:	8526                	mv	a0,s1
    800033d0:	fffff097          	auipc	ra,0xfffff
    800033d4:	fe8080e7          	jalr	-24(ra) # 800023b8 <bwrite>
    if(recovering == 0)
    800033d8:	f80b1ce3          	bnez	s6,80003370 <install_trans+0x36>
      bunpin(dbuf);
    800033dc:	8526                	mv	a0,s1
    800033de:	fffff097          	auipc	ra,0xfffff
    800033e2:	0f2080e7          	jalr	242(ra) # 800024d0 <bunpin>
    800033e6:	b769                	j	80003370 <install_trans+0x36>
}
    800033e8:	70e2                	ld	ra,56(sp)
    800033ea:	7442                	ld	s0,48(sp)
    800033ec:	74a2                	ld	s1,40(sp)
    800033ee:	7902                	ld	s2,32(sp)
    800033f0:	69e2                	ld	s3,24(sp)
    800033f2:	6a42                	ld	s4,16(sp)
    800033f4:	6aa2                	ld	s5,8(sp)
    800033f6:	6b02                	ld	s6,0(sp)
    800033f8:	6121                	addi	sp,sp,64
    800033fa:	8082                	ret
    800033fc:	8082                	ret

00000000800033fe <initlog>:
{
    800033fe:	7179                	addi	sp,sp,-48
    80003400:	f406                	sd	ra,40(sp)
    80003402:	f022                	sd	s0,32(sp)
    80003404:	ec26                	sd	s1,24(sp)
    80003406:	e84a                	sd	s2,16(sp)
    80003408:	e44e                	sd	s3,8(sp)
    8000340a:	1800                	addi	s0,sp,48
    8000340c:	892a                	mv	s2,a0
    8000340e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003410:	00015497          	auipc	s1,0x15
    80003414:	4a048493          	addi	s1,s1,1184 # 800188b0 <log>
    80003418:	00005597          	auipc	a1,0x5
    8000341c:	19058593          	addi	a1,a1,400 # 800085a8 <syscalls+0x1d8>
    80003420:	8526                	mv	a0,s1
    80003422:	00003097          	auipc	ra,0x3
    80003426:	c18080e7          	jalr	-1000(ra) # 8000603a <initlock>
  log.start = sb->logstart;
    8000342a:	0149a583          	lw	a1,20(s3)
    8000342e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003430:	0109a783          	lw	a5,16(s3)
    80003434:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003436:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000343a:	854a                	mv	a0,s2
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	e8a080e7          	jalr	-374(ra) # 800022c6 <bread>
  log.lh.n = lh->n;
    80003444:	4d34                	lw	a3,88(a0)
    80003446:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003448:	02d05563          	blez	a3,80003472 <initlog+0x74>
    8000344c:	05c50793          	addi	a5,a0,92
    80003450:	00015717          	auipc	a4,0x15
    80003454:	49070713          	addi	a4,a4,1168 # 800188e0 <log+0x30>
    80003458:	36fd                	addiw	a3,a3,-1
    8000345a:	1682                	slli	a3,a3,0x20
    8000345c:	9281                	srli	a3,a3,0x20
    8000345e:	068a                	slli	a3,a3,0x2
    80003460:	06050613          	addi	a2,a0,96
    80003464:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003466:	4390                	lw	a2,0(a5)
    80003468:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000346a:	0791                	addi	a5,a5,4
    8000346c:	0711                	addi	a4,a4,4
    8000346e:	fed79ce3          	bne	a5,a3,80003466 <initlog+0x68>
  brelse(buf);
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	f84080e7          	jalr	-124(ra) # 800023f6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000347a:	4505                	li	a0,1
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	ebe080e7          	jalr	-322(ra) # 8000333a <install_trans>
  log.lh.n = 0;
    80003484:	00015797          	auipc	a5,0x15
    80003488:	4407ac23          	sw	zero,1112(a5) # 800188dc <log+0x2c>
  write_head(); // clear the log
    8000348c:	00000097          	auipc	ra,0x0
    80003490:	e34080e7          	jalr	-460(ra) # 800032c0 <write_head>
}
    80003494:	70a2                	ld	ra,40(sp)
    80003496:	7402                	ld	s0,32(sp)
    80003498:	64e2                	ld	s1,24(sp)
    8000349a:	6942                	ld	s2,16(sp)
    8000349c:	69a2                	ld	s3,8(sp)
    8000349e:	6145                	addi	sp,sp,48
    800034a0:	8082                	ret

00000000800034a2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034a2:	1101                	addi	sp,sp,-32
    800034a4:	ec06                	sd	ra,24(sp)
    800034a6:	e822                	sd	s0,16(sp)
    800034a8:	e426                	sd	s1,8(sp)
    800034aa:	e04a                	sd	s2,0(sp)
    800034ac:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034ae:	00015517          	auipc	a0,0x15
    800034b2:	40250513          	addi	a0,a0,1026 # 800188b0 <log>
    800034b6:	00003097          	auipc	ra,0x3
    800034ba:	c14080e7          	jalr	-1004(ra) # 800060ca <acquire>
  while(1){
    if(log.committing){
    800034be:	00015497          	auipc	s1,0x15
    800034c2:	3f248493          	addi	s1,s1,1010 # 800188b0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034c6:	4979                	li	s2,30
    800034c8:	a039                	j	800034d6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034ca:	85a6                	mv	a1,s1
    800034cc:	8526                	mv	a0,s1
    800034ce:	ffffe097          	auipc	ra,0xffffe
    800034d2:	02c080e7          	jalr	44(ra) # 800014fa <sleep>
    if(log.committing){
    800034d6:	50dc                	lw	a5,36(s1)
    800034d8:	fbed                	bnez	a5,800034ca <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034da:	509c                	lw	a5,32(s1)
    800034dc:	0017871b          	addiw	a4,a5,1
    800034e0:	0007069b          	sext.w	a3,a4
    800034e4:	0027179b          	slliw	a5,a4,0x2
    800034e8:	9fb9                	addw	a5,a5,a4
    800034ea:	0017979b          	slliw	a5,a5,0x1
    800034ee:	54d8                	lw	a4,44(s1)
    800034f0:	9fb9                	addw	a5,a5,a4
    800034f2:	00f95963          	bge	s2,a5,80003504 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034f6:	85a6                	mv	a1,s1
    800034f8:	8526                	mv	a0,s1
    800034fa:	ffffe097          	auipc	ra,0xffffe
    800034fe:	000080e7          	jalr	ra # 800014fa <sleep>
    80003502:	bfd1                	j	800034d6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003504:	00015517          	auipc	a0,0x15
    80003508:	3ac50513          	addi	a0,a0,940 # 800188b0 <log>
    8000350c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000350e:	00003097          	auipc	ra,0x3
    80003512:	c70080e7          	jalr	-912(ra) # 8000617e <release>
      break;
    }
  }
}
    80003516:	60e2                	ld	ra,24(sp)
    80003518:	6442                	ld	s0,16(sp)
    8000351a:	64a2                	ld	s1,8(sp)
    8000351c:	6902                	ld	s2,0(sp)
    8000351e:	6105                	addi	sp,sp,32
    80003520:	8082                	ret

0000000080003522 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003522:	7139                	addi	sp,sp,-64
    80003524:	fc06                	sd	ra,56(sp)
    80003526:	f822                	sd	s0,48(sp)
    80003528:	f426                	sd	s1,40(sp)
    8000352a:	f04a                	sd	s2,32(sp)
    8000352c:	ec4e                	sd	s3,24(sp)
    8000352e:	e852                	sd	s4,16(sp)
    80003530:	e456                	sd	s5,8(sp)
    80003532:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003534:	00015497          	auipc	s1,0x15
    80003538:	37c48493          	addi	s1,s1,892 # 800188b0 <log>
    8000353c:	8526                	mv	a0,s1
    8000353e:	00003097          	auipc	ra,0x3
    80003542:	b8c080e7          	jalr	-1140(ra) # 800060ca <acquire>
  log.outstanding -= 1;
    80003546:	509c                	lw	a5,32(s1)
    80003548:	37fd                	addiw	a5,a5,-1
    8000354a:	0007891b          	sext.w	s2,a5
    8000354e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003550:	50dc                	lw	a5,36(s1)
    80003552:	e7b9                	bnez	a5,800035a0 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003554:	04091e63          	bnez	s2,800035b0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003558:	00015497          	auipc	s1,0x15
    8000355c:	35848493          	addi	s1,s1,856 # 800188b0 <log>
    80003560:	4785                	li	a5,1
    80003562:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003564:	8526                	mv	a0,s1
    80003566:	00003097          	auipc	ra,0x3
    8000356a:	c18080e7          	jalr	-1000(ra) # 8000617e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000356e:	54dc                	lw	a5,44(s1)
    80003570:	06f04763          	bgtz	a5,800035de <end_op+0xbc>
    acquire(&log.lock);
    80003574:	00015497          	auipc	s1,0x15
    80003578:	33c48493          	addi	s1,s1,828 # 800188b0 <log>
    8000357c:	8526                	mv	a0,s1
    8000357e:	00003097          	auipc	ra,0x3
    80003582:	b4c080e7          	jalr	-1204(ra) # 800060ca <acquire>
    log.committing = 0;
    80003586:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000358a:	8526                	mv	a0,s1
    8000358c:	ffffe097          	auipc	ra,0xffffe
    80003590:	fd2080e7          	jalr	-46(ra) # 8000155e <wakeup>
    release(&log.lock);
    80003594:	8526                	mv	a0,s1
    80003596:	00003097          	auipc	ra,0x3
    8000359a:	be8080e7          	jalr	-1048(ra) # 8000617e <release>
}
    8000359e:	a03d                	j	800035cc <end_op+0xaa>
    panic("log.committing");
    800035a0:	00005517          	auipc	a0,0x5
    800035a4:	01050513          	addi	a0,a0,16 # 800085b0 <syscalls+0x1e0>
    800035a8:	00002097          	auipc	ra,0x2
    800035ac:	5e6080e7          	jalr	1510(ra) # 80005b8e <panic>
    wakeup(&log);
    800035b0:	00015497          	auipc	s1,0x15
    800035b4:	30048493          	addi	s1,s1,768 # 800188b0 <log>
    800035b8:	8526                	mv	a0,s1
    800035ba:	ffffe097          	auipc	ra,0xffffe
    800035be:	fa4080e7          	jalr	-92(ra) # 8000155e <wakeup>
  release(&log.lock);
    800035c2:	8526                	mv	a0,s1
    800035c4:	00003097          	auipc	ra,0x3
    800035c8:	bba080e7          	jalr	-1094(ra) # 8000617e <release>
}
    800035cc:	70e2                	ld	ra,56(sp)
    800035ce:	7442                	ld	s0,48(sp)
    800035d0:	74a2                	ld	s1,40(sp)
    800035d2:	7902                	ld	s2,32(sp)
    800035d4:	69e2                	ld	s3,24(sp)
    800035d6:	6a42                	ld	s4,16(sp)
    800035d8:	6aa2                	ld	s5,8(sp)
    800035da:	6121                	addi	sp,sp,64
    800035dc:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800035de:	00015a97          	auipc	s5,0x15
    800035e2:	302a8a93          	addi	s5,s5,770 # 800188e0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035e6:	00015a17          	auipc	s4,0x15
    800035ea:	2caa0a13          	addi	s4,s4,714 # 800188b0 <log>
    800035ee:	018a2583          	lw	a1,24(s4)
    800035f2:	012585bb          	addw	a1,a1,s2
    800035f6:	2585                	addiw	a1,a1,1
    800035f8:	028a2503          	lw	a0,40(s4)
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	cca080e7          	jalr	-822(ra) # 800022c6 <bread>
    80003604:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003606:	000aa583          	lw	a1,0(s5)
    8000360a:	028a2503          	lw	a0,40(s4)
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	cb8080e7          	jalr	-840(ra) # 800022c6 <bread>
    80003616:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003618:	40000613          	li	a2,1024
    8000361c:	05850593          	addi	a1,a0,88
    80003620:	05848513          	addi	a0,s1,88
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	bb0080e7          	jalr	-1104(ra) # 800001d4 <memmove>
    bwrite(to);  // write the log
    8000362c:	8526                	mv	a0,s1
    8000362e:	fffff097          	auipc	ra,0xfffff
    80003632:	d8a080e7          	jalr	-630(ra) # 800023b8 <bwrite>
    brelse(from);
    80003636:	854e                	mv	a0,s3
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	dbe080e7          	jalr	-578(ra) # 800023f6 <brelse>
    brelse(to);
    80003640:	8526                	mv	a0,s1
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	db4080e7          	jalr	-588(ra) # 800023f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000364a:	2905                	addiw	s2,s2,1
    8000364c:	0a91                	addi	s5,s5,4
    8000364e:	02ca2783          	lw	a5,44(s4)
    80003652:	f8f94ee3          	blt	s2,a5,800035ee <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003656:	00000097          	auipc	ra,0x0
    8000365a:	c6a080e7          	jalr	-918(ra) # 800032c0 <write_head>
    install_trans(0); // Now install writes to home locations
    8000365e:	4501                	li	a0,0
    80003660:	00000097          	auipc	ra,0x0
    80003664:	cda080e7          	jalr	-806(ra) # 8000333a <install_trans>
    log.lh.n = 0;
    80003668:	00015797          	auipc	a5,0x15
    8000366c:	2607aa23          	sw	zero,628(a5) # 800188dc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003670:	00000097          	auipc	ra,0x0
    80003674:	c50080e7          	jalr	-944(ra) # 800032c0 <write_head>
    80003678:	bdf5                	j	80003574 <end_op+0x52>

000000008000367a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000367a:	1101                	addi	sp,sp,-32
    8000367c:	ec06                	sd	ra,24(sp)
    8000367e:	e822                	sd	s0,16(sp)
    80003680:	e426                	sd	s1,8(sp)
    80003682:	e04a                	sd	s2,0(sp)
    80003684:	1000                	addi	s0,sp,32
    80003686:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003688:	00015917          	auipc	s2,0x15
    8000368c:	22890913          	addi	s2,s2,552 # 800188b0 <log>
    80003690:	854a                	mv	a0,s2
    80003692:	00003097          	auipc	ra,0x3
    80003696:	a38080e7          	jalr	-1480(ra) # 800060ca <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000369a:	02c92603          	lw	a2,44(s2)
    8000369e:	47f5                	li	a5,29
    800036a0:	06c7c563          	blt	a5,a2,8000370a <log_write+0x90>
    800036a4:	00015797          	auipc	a5,0x15
    800036a8:	2287a783          	lw	a5,552(a5) # 800188cc <log+0x1c>
    800036ac:	37fd                	addiw	a5,a5,-1
    800036ae:	04f65e63          	bge	a2,a5,8000370a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036b2:	00015797          	auipc	a5,0x15
    800036b6:	21e7a783          	lw	a5,542(a5) # 800188d0 <log+0x20>
    800036ba:	06f05063          	blez	a5,8000371a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036be:	4781                	li	a5,0
    800036c0:	06c05563          	blez	a2,8000372a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036c4:	44cc                	lw	a1,12(s1)
    800036c6:	00015717          	auipc	a4,0x15
    800036ca:	21a70713          	addi	a4,a4,538 # 800188e0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036ce:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036d0:	4314                	lw	a3,0(a4)
    800036d2:	04b68c63          	beq	a3,a1,8000372a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036d6:	2785                	addiw	a5,a5,1
    800036d8:	0711                	addi	a4,a4,4
    800036da:	fef61be3          	bne	a2,a5,800036d0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036de:	0621                	addi	a2,a2,8
    800036e0:	060a                	slli	a2,a2,0x2
    800036e2:	00015797          	auipc	a5,0x15
    800036e6:	1ce78793          	addi	a5,a5,462 # 800188b0 <log>
    800036ea:	963e                	add	a2,a2,a5
    800036ec:	44dc                	lw	a5,12(s1)
    800036ee:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036f0:	8526                	mv	a0,s1
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	da2080e7          	jalr	-606(ra) # 80002494 <bpin>
    log.lh.n++;
    800036fa:	00015717          	auipc	a4,0x15
    800036fe:	1b670713          	addi	a4,a4,438 # 800188b0 <log>
    80003702:	575c                	lw	a5,44(a4)
    80003704:	2785                	addiw	a5,a5,1
    80003706:	d75c                	sw	a5,44(a4)
    80003708:	a835                	j	80003744 <log_write+0xca>
    panic("too big a transaction");
    8000370a:	00005517          	auipc	a0,0x5
    8000370e:	eb650513          	addi	a0,a0,-330 # 800085c0 <syscalls+0x1f0>
    80003712:	00002097          	auipc	ra,0x2
    80003716:	47c080e7          	jalr	1148(ra) # 80005b8e <panic>
    panic("log_write outside of trans");
    8000371a:	00005517          	auipc	a0,0x5
    8000371e:	ebe50513          	addi	a0,a0,-322 # 800085d8 <syscalls+0x208>
    80003722:	00002097          	auipc	ra,0x2
    80003726:	46c080e7          	jalr	1132(ra) # 80005b8e <panic>
  log.lh.block[i] = b->blockno;
    8000372a:	00878713          	addi	a4,a5,8
    8000372e:	00271693          	slli	a3,a4,0x2
    80003732:	00015717          	auipc	a4,0x15
    80003736:	17e70713          	addi	a4,a4,382 # 800188b0 <log>
    8000373a:	9736                	add	a4,a4,a3
    8000373c:	44d4                	lw	a3,12(s1)
    8000373e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003740:	faf608e3          	beq	a2,a5,800036f0 <log_write+0x76>
  }
  release(&log.lock);
    80003744:	00015517          	auipc	a0,0x15
    80003748:	16c50513          	addi	a0,a0,364 # 800188b0 <log>
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	a32080e7          	jalr	-1486(ra) # 8000617e <release>
}
    80003754:	60e2                	ld	ra,24(sp)
    80003756:	6442                	ld	s0,16(sp)
    80003758:	64a2                	ld	s1,8(sp)
    8000375a:	6902                	ld	s2,0(sp)
    8000375c:	6105                	addi	sp,sp,32
    8000375e:	8082                	ret

0000000080003760 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003760:	1101                	addi	sp,sp,-32
    80003762:	ec06                	sd	ra,24(sp)
    80003764:	e822                	sd	s0,16(sp)
    80003766:	e426                	sd	s1,8(sp)
    80003768:	e04a                	sd	s2,0(sp)
    8000376a:	1000                	addi	s0,sp,32
    8000376c:	84aa                	mv	s1,a0
    8000376e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003770:	00005597          	auipc	a1,0x5
    80003774:	e8858593          	addi	a1,a1,-376 # 800085f8 <syscalls+0x228>
    80003778:	0521                	addi	a0,a0,8
    8000377a:	00003097          	auipc	ra,0x3
    8000377e:	8c0080e7          	jalr	-1856(ra) # 8000603a <initlock>
  lk->name = name;
    80003782:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003786:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000378a:	0204a423          	sw	zero,40(s1)
}
    8000378e:	60e2                	ld	ra,24(sp)
    80003790:	6442                	ld	s0,16(sp)
    80003792:	64a2                	ld	s1,8(sp)
    80003794:	6902                	ld	s2,0(sp)
    80003796:	6105                	addi	sp,sp,32
    80003798:	8082                	ret

000000008000379a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000379a:	1101                	addi	sp,sp,-32
    8000379c:	ec06                	sd	ra,24(sp)
    8000379e:	e822                	sd	s0,16(sp)
    800037a0:	e426                	sd	s1,8(sp)
    800037a2:	e04a                	sd	s2,0(sp)
    800037a4:	1000                	addi	s0,sp,32
    800037a6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037a8:	00850913          	addi	s2,a0,8
    800037ac:	854a                	mv	a0,s2
    800037ae:	00003097          	auipc	ra,0x3
    800037b2:	91c080e7          	jalr	-1764(ra) # 800060ca <acquire>
  while (lk->locked) {
    800037b6:	409c                	lw	a5,0(s1)
    800037b8:	cb89                	beqz	a5,800037ca <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037ba:	85ca                	mv	a1,s2
    800037bc:	8526                	mv	a0,s1
    800037be:	ffffe097          	auipc	ra,0xffffe
    800037c2:	d3c080e7          	jalr	-708(ra) # 800014fa <sleep>
  while (lk->locked) {
    800037c6:	409c                	lw	a5,0(s1)
    800037c8:	fbed                	bnez	a5,800037ba <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037ca:	4785                	li	a5,1
    800037cc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037ce:	ffffd097          	auipc	ra,0xffffd
    800037d2:	684080e7          	jalr	1668(ra) # 80000e52 <myproc>
    800037d6:	591c                	lw	a5,48(a0)
    800037d8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037da:	854a                	mv	a0,s2
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	9a2080e7          	jalr	-1630(ra) # 8000617e <release>
}
    800037e4:	60e2                	ld	ra,24(sp)
    800037e6:	6442                	ld	s0,16(sp)
    800037e8:	64a2                	ld	s1,8(sp)
    800037ea:	6902                	ld	s2,0(sp)
    800037ec:	6105                	addi	sp,sp,32
    800037ee:	8082                	ret

00000000800037f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037f0:	1101                	addi	sp,sp,-32
    800037f2:	ec06                	sd	ra,24(sp)
    800037f4:	e822                	sd	s0,16(sp)
    800037f6:	e426                	sd	s1,8(sp)
    800037f8:	e04a                	sd	s2,0(sp)
    800037fa:	1000                	addi	s0,sp,32
    800037fc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037fe:	00850913          	addi	s2,a0,8
    80003802:	854a                	mv	a0,s2
    80003804:	00003097          	auipc	ra,0x3
    80003808:	8c6080e7          	jalr	-1850(ra) # 800060ca <acquire>
  lk->locked = 0;
    8000380c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003810:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003814:	8526                	mv	a0,s1
    80003816:	ffffe097          	auipc	ra,0xffffe
    8000381a:	d48080e7          	jalr	-696(ra) # 8000155e <wakeup>
  release(&lk->lk);
    8000381e:	854a                	mv	a0,s2
    80003820:	00003097          	auipc	ra,0x3
    80003824:	95e080e7          	jalr	-1698(ra) # 8000617e <release>
}
    80003828:	60e2                	ld	ra,24(sp)
    8000382a:	6442                	ld	s0,16(sp)
    8000382c:	64a2                	ld	s1,8(sp)
    8000382e:	6902                	ld	s2,0(sp)
    80003830:	6105                	addi	sp,sp,32
    80003832:	8082                	ret

0000000080003834 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003834:	7179                	addi	sp,sp,-48
    80003836:	f406                	sd	ra,40(sp)
    80003838:	f022                	sd	s0,32(sp)
    8000383a:	ec26                	sd	s1,24(sp)
    8000383c:	e84a                	sd	s2,16(sp)
    8000383e:	e44e                	sd	s3,8(sp)
    80003840:	1800                	addi	s0,sp,48
    80003842:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003844:	00850913          	addi	s2,a0,8
    80003848:	854a                	mv	a0,s2
    8000384a:	00003097          	auipc	ra,0x3
    8000384e:	880080e7          	jalr	-1920(ra) # 800060ca <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003852:	409c                	lw	a5,0(s1)
    80003854:	ef99                	bnez	a5,80003872 <holdingsleep+0x3e>
    80003856:	4481                	li	s1,0
  release(&lk->lk);
    80003858:	854a                	mv	a0,s2
    8000385a:	00003097          	auipc	ra,0x3
    8000385e:	924080e7          	jalr	-1756(ra) # 8000617e <release>
  return r;
}
    80003862:	8526                	mv	a0,s1
    80003864:	70a2                	ld	ra,40(sp)
    80003866:	7402                	ld	s0,32(sp)
    80003868:	64e2                	ld	s1,24(sp)
    8000386a:	6942                	ld	s2,16(sp)
    8000386c:	69a2                	ld	s3,8(sp)
    8000386e:	6145                	addi	sp,sp,48
    80003870:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003872:	0284a983          	lw	s3,40(s1)
    80003876:	ffffd097          	auipc	ra,0xffffd
    8000387a:	5dc080e7          	jalr	1500(ra) # 80000e52 <myproc>
    8000387e:	5904                	lw	s1,48(a0)
    80003880:	413484b3          	sub	s1,s1,s3
    80003884:	0014b493          	seqz	s1,s1
    80003888:	bfc1                	j	80003858 <holdingsleep+0x24>

000000008000388a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000388a:	1141                	addi	sp,sp,-16
    8000388c:	e406                	sd	ra,8(sp)
    8000388e:	e022                	sd	s0,0(sp)
    80003890:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003892:	00005597          	auipc	a1,0x5
    80003896:	d7658593          	addi	a1,a1,-650 # 80008608 <syscalls+0x238>
    8000389a:	00015517          	auipc	a0,0x15
    8000389e:	15e50513          	addi	a0,a0,350 # 800189f8 <ftable>
    800038a2:	00002097          	auipc	ra,0x2
    800038a6:	798080e7          	jalr	1944(ra) # 8000603a <initlock>
}
    800038aa:	60a2                	ld	ra,8(sp)
    800038ac:	6402                	ld	s0,0(sp)
    800038ae:	0141                	addi	sp,sp,16
    800038b0:	8082                	ret

00000000800038b2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038b2:	1101                	addi	sp,sp,-32
    800038b4:	ec06                	sd	ra,24(sp)
    800038b6:	e822                	sd	s0,16(sp)
    800038b8:	e426                	sd	s1,8(sp)
    800038ba:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038bc:	00015517          	auipc	a0,0x15
    800038c0:	13c50513          	addi	a0,a0,316 # 800189f8 <ftable>
    800038c4:	00003097          	auipc	ra,0x3
    800038c8:	806080e7          	jalr	-2042(ra) # 800060ca <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038cc:	00015497          	auipc	s1,0x15
    800038d0:	14448493          	addi	s1,s1,324 # 80018a10 <ftable+0x18>
    800038d4:	00016717          	auipc	a4,0x16
    800038d8:	0dc70713          	addi	a4,a4,220 # 800199b0 <disk>
    if(f->ref == 0){
    800038dc:	40dc                	lw	a5,4(s1)
    800038de:	cf99                	beqz	a5,800038fc <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e0:	02848493          	addi	s1,s1,40
    800038e4:	fee49ce3          	bne	s1,a4,800038dc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038e8:	00015517          	auipc	a0,0x15
    800038ec:	11050513          	addi	a0,a0,272 # 800189f8 <ftable>
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	88e080e7          	jalr	-1906(ra) # 8000617e <release>
  return 0;
    800038f8:	4481                	li	s1,0
    800038fa:	a819                	j	80003910 <filealloc+0x5e>
      f->ref = 1;
    800038fc:	4785                	li	a5,1
    800038fe:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003900:	00015517          	auipc	a0,0x15
    80003904:	0f850513          	addi	a0,a0,248 # 800189f8 <ftable>
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	876080e7          	jalr	-1930(ra) # 8000617e <release>
}
    80003910:	8526                	mv	a0,s1
    80003912:	60e2                	ld	ra,24(sp)
    80003914:	6442                	ld	s0,16(sp)
    80003916:	64a2                	ld	s1,8(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	1000                	addi	s0,sp,32
    80003926:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003928:	00015517          	auipc	a0,0x15
    8000392c:	0d050513          	addi	a0,a0,208 # 800189f8 <ftable>
    80003930:	00002097          	auipc	ra,0x2
    80003934:	79a080e7          	jalr	1946(ra) # 800060ca <acquire>
  if(f->ref < 1)
    80003938:	40dc                	lw	a5,4(s1)
    8000393a:	02f05263          	blez	a5,8000395e <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000393e:	2785                	addiw	a5,a5,1
    80003940:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003942:	00015517          	auipc	a0,0x15
    80003946:	0b650513          	addi	a0,a0,182 # 800189f8 <ftable>
    8000394a:	00003097          	auipc	ra,0x3
    8000394e:	834080e7          	jalr	-1996(ra) # 8000617e <release>
  return f;
}
    80003952:	8526                	mv	a0,s1
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6105                	addi	sp,sp,32
    8000395c:	8082                	ret
    panic("filedup");
    8000395e:	00005517          	auipc	a0,0x5
    80003962:	cb250513          	addi	a0,a0,-846 # 80008610 <syscalls+0x240>
    80003966:	00002097          	auipc	ra,0x2
    8000396a:	228080e7          	jalr	552(ra) # 80005b8e <panic>

000000008000396e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000396e:	7139                	addi	sp,sp,-64
    80003970:	fc06                	sd	ra,56(sp)
    80003972:	f822                	sd	s0,48(sp)
    80003974:	f426                	sd	s1,40(sp)
    80003976:	f04a                	sd	s2,32(sp)
    80003978:	ec4e                	sd	s3,24(sp)
    8000397a:	e852                	sd	s4,16(sp)
    8000397c:	e456                	sd	s5,8(sp)
    8000397e:	0080                	addi	s0,sp,64
    80003980:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003982:	00015517          	auipc	a0,0x15
    80003986:	07650513          	addi	a0,a0,118 # 800189f8 <ftable>
    8000398a:	00002097          	auipc	ra,0x2
    8000398e:	740080e7          	jalr	1856(ra) # 800060ca <acquire>
  if(f->ref < 1)
    80003992:	40dc                	lw	a5,4(s1)
    80003994:	06f05163          	blez	a5,800039f6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003998:	37fd                	addiw	a5,a5,-1
    8000399a:	0007871b          	sext.w	a4,a5
    8000399e:	c0dc                	sw	a5,4(s1)
    800039a0:	06e04363          	bgtz	a4,80003a06 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039a4:	0004a903          	lw	s2,0(s1)
    800039a8:	0094ca83          	lbu	s5,9(s1)
    800039ac:	0104ba03          	ld	s4,16(s1)
    800039b0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039b4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039b8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039bc:	00015517          	auipc	a0,0x15
    800039c0:	03c50513          	addi	a0,a0,60 # 800189f8 <ftable>
    800039c4:	00002097          	auipc	ra,0x2
    800039c8:	7ba080e7          	jalr	1978(ra) # 8000617e <release>

  if(ff.type == FD_PIPE){
    800039cc:	4785                	li	a5,1
    800039ce:	04f90d63          	beq	s2,a5,80003a28 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039d2:	3979                	addiw	s2,s2,-2
    800039d4:	4785                	li	a5,1
    800039d6:	0527e063          	bltu	a5,s2,80003a16 <fileclose+0xa8>
    begin_op();
    800039da:	00000097          	auipc	ra,0x0
    800039de:	ac8080e7          	jalr	-1336(ra) # 800034a2 <begin_op>
    iput(ff.ip);
    800039e2:	854e                	mv	a0,s3
    800039e4:	fffff097          	auipc	ra,0xfffff
    800039e8:	2b6080e7          	jalr	694(ra) # 80002c9a <iput>
    end_op();
    800039ec:	00000097          	auipc	ra,0x0
    800039f0:	b36080e7          	jalr	-1226(ra) # 80003522 <end_op>
    800039f4:	a00d                	j	80003a16 <fileclose+0xa8>
    panic("fileclose");
    800039f6:	00005517          	auipc	a0,0x5
    800039fa:	c2250513          	addi	a0,a0,-990 # 80008618 <syscalls+0x248>
    800039fe:	00002097          	auipc	ra,0x2
    80003a02:	190080e7          	jalr	400(ra) # 80005b8e <panic>
    release(&ftable.lock);
    80003a06:	00015517          	auipc	a0,0x15
    80003a0a:	ff250513          	addi	a0,a0,-14 # 800189f8 <ftable>
    80003a0e:	00002097          	auipc	ra,0x2
    80003a12:	770080e7          	jalr	1904(ra) # 8000617e <release>
  }
}
    80003a16:	70e2                	ld	ra,56(sp)
    80003a18:	7442                	ld	s0,48(sp)
    80003a1a:	74a2                	ld	s1,40(sp)
    80003a1c:	7902                	ld	s2,32(sp)
    80003a1e:	69e2                	ld	s3,24(sp)
    80003a20:	6a42                	ld	s4,16(sp)
    80003a22:	6aa2                	ld	s5,8(sp)
    80003a24:	6121                	addi	sp,sp,64
    80003a26:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a28:	85d6                	mv	a1,s5
    80003a2a:	8552                	mv	a0,s4
    80003a2c:	00000097          	auipc	ra,0x0
    80003a30:	34c080e7          	jalr	844(ra) # 80003d78 <pipeclose>
    80003a34:	b7cd                	j	80003a16 <fileclose+0xa8>

0000000080003a36 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a36:	715d                	addi	sp,sp,-80
    80003a38:	e486                	sd	ra,72(sp)
    80003a3a:	e0a2                	sd	s0,64(sp)
    80003a3c:	fc26                	sd	s1,56(sp)
    80003a3e:	f84a                	sd	s2,48(sp)
    80003a40:	f44e                	sd	s3,40(sp)
    80003a42:	0880                	addi	s0,sp,80
    80003a44:	84aa                	mv	s1,a0
    80003a46:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a48:	ffffd097          	auipc	ra,0xffffd
    80003a4c:	40a080e7          	jalr	1034(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a50:	409c                	lw	a5,0(s1)
    80003a52:	37f9                	addiw	a5,a5,-2
    80003a54:	4705                	li	a4,1
    80003a56:	04f76763          	bltu	a4,a5,80003aa4 <filestat+0x6e>
    80003a5a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a5c:	6c88                	ld	a0,24(s1)
    80003a5e:	fffff097          	auipc	ra,0xfffff
    80003a62:	082080e7          	jalr	130(ra) # 80002ae0 <ilock>
    stati(f->ip, &st);
    80003a66:	fb840593          	addi	a1,s0,-72
    80003a6a:	6c88                	ld	a0,24(s1)
    80003a6c:	fffff097          	auipc	ra,0xfffff
    80003a70:	2fe080e7          	jalr	766(ra) # 80002d6a <stati>
    iunlock(f->ip);
    80003a74:	6c88                	ld	a0,24(s1)
    80003a76:	fffff097          	auipc	ra,0xfffff
    80003a7a:	12c080e7          	jalr	300(ra) # 80002ba2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a7e:	46e1                	li	a3,24
    80003a80:	fb840613          	addi	a2,s0,-72
    80003a84:	85ce                	mv	a1,s3
    80003a86:	05093503          	ld	a0,80(s2)
    80003a8a:	ffffd097          	auipc	ra,0xffffd
    80003a8e:	084080e7          	jalr	132(ra) # 80000b0e <copyout>
    80003a92:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a96:	60a6                	ld	ra,72(sp)
    80003a98:	6406                	ld	s0,64(sp)
    80003a9a:	74e2                	ld	s1,56(sp)
    80003a9c:	7942                	ld	s2,48(sp)
    80003a9e:	79a2                	ld	s3,40(sp)
    80003aa0:	6161                	addi	sp,sp,80
    80003aa2:	8082                	ret
  return -1;
    80003aa4:	557d                	li	a0,-1
    80003aa6:	bfc5                	j	80003a96 <filestat+0x60>

0000000080003aa8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aa8:	7179                	addi	sp,sp,-48
    80003aaa:	f406                	sd	ra,40(sp)
    80003aac:	f022                	sd	s0,32(sp)
    80003aae:	ec26                	sd	s1,24(sp)
    80003ab0:	e84a                	sd	s2,16(sp)
    80003ab2:	e44e                	sd	s3,8(sp)
    80003ab4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ab6:	00854783          	lbu	a5,8(a0)
    80003aba:	c3d5                	beqz	a5,80003b5e <fileread+0xb6>
    80003abc:	84aa                	mv	s1,a0
    80003abe:	89ae                	mv	s3,a1
    80003ac0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ac2:	411c                	lw	a5,0(a0)
    80003ac4:	4705                	li	a4,1
    80003ac6:	04e78963          	beq	a5,a4,80003b18 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003aca:	470d                	li	a4,3
    80003acc:	04e78d63          	beq	a5,a4,80003b26 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ad0:	4709                	li	a4,2
    80003ad2:	06e79e63          	bne	a5,a4,80003b4e <fileread+0xa6>
    ilock(f->ip);
    80003ad6:	6d08                	ld	a0,24(a0)
    80003ad8:	fffff097          	auipc	ra,0xfffff
    80003adc:	008080e7          	jalr	8(ra) # 80002ae0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ae0:	874a                	mv	a4,s2
    80003ae2:	5094                	lw	a3,32(s1)
    80003ae4:	864e                	mv	a2,s3
    80003ae6:	4585                	li	a1,1
    80003ae8:	6c88                	ld	a0,24(s1)
    80003aea:	fffff097          	auipc	ra,0xfffff
    80003aee:	2aa080e7          	jalr	682(ra) # 80002d94 <readi>
    80003af2:	892a                	mv	s2,a0
    80003af4:	00a05563          	blez	a0,80003afe <fileread+0x56>
      f->off += r;
    80003af8:	509c                	lw	a5,32(s1)
    80003afa:	9fa9                	addw	a5,a5,a0
    80003afc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003afe:	6c88                	ld	a0,24(s1)
    80003b00:	fffff097          	auipc	ra,0xfffff
    80003b04:	0a2080e7          	jalr	162(ra) # 80002ba2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b08:	854a                	mv	a0,s2
    80003b0a:	70a2                	ld	ra,40(sp)
    80003b0c:	7402                	ld	s0,32(sp)
    80003b0e:	64e2                	ld	s1,24(sp)
    80003b10:	6942                	ld	s2,16(sp)
    80003b12:	69a2                	ld	s3,8(sp)
    80003b14:	6145                	addi	sp,sp,48
    80003b16:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b18:	6908                	ld	a0,16(a0)
    80003b1a:	00000097          	auipc	ra,0x0
    80003b1e:	3c6080e7          	jalr	966(ra) # 80003ee0 <piperead>
    80003b22:	892a                	mv	s2,a0
    80003b24:	b7d5                	j	80003b08 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b26:	02451783          	lh	a5,36(a0)
    80003b2a:	03079693          	slli	a3,a5,0x30
    80003b2e:	92c1                	srli	a3,a3,0x30
    80003b30:	4725                	li	a4,9
    80003b32:	02d76863          	bltu	a4,a3,80003b62 <fileread+0xba>
    80003b36:	0792                	slli	a5,a5,0x4
    80003b38:	00015717          	auipc	a4,0x15
    80003b3c:	e2070713          	addi	a4,a4,-480 # 80018958 <devsw>
    80003b40:	97ba                	add	a5,a5,a4
    80003b42:	639c                	ld	a5,0(a5)
    80003b44:	c38d                	beqz	a5,80003b66 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b46:	4505                	li	a0,1
    80003b48:	9782                	jalr	a5
    80003b4a:	892a                	mv	s2,a0
    80003b4c:	bf75                	j	80003b08 <fileread+0x60>
    panic("fileread");
    80003b4e:	00005517          	auipc	a0,0x5
    80003b52:	ada50513          	addi	a0,a0,-1318 # 80008628 <syscalls+0x258>
    80003b56:	00002097          	auipc	ra,0x2
    80003b5a:	038080e7          	jalr	56(ra) # 80005b8e <panic>
    return -1;
    80003b5e:	597d                	li	s2,-1
    80003b60:	b765                	j	80003b08 <fileread+0x60>
      return -1;
    80003b62:	597d                	li	s2,-1
    80003b64:	b755                	j	80003b08 <fileread+0x60>
    80003b66:	597d                	li	s2,-1
    80003b68:	b745                	j	80003b08 <fileread+0x60>

0000000080003b6a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b6a:	715d                	addi	sp,sp,-80
    80003b6c:	e486                	sd	ra,72(sp)
    80003b6e:	e0a2                	sd	s0,64(sp)
    80003b70:	fc26                	sd	s1,56(sp)
    80003b72:	f84a                	sd	s2,48(sp)
    80003b74:	f44e                	sd	s3,40(sp)
    80003b76:	f052                	sd	s4,32(sp)
    80003b78:	ec56                	sd	s5,24(sp)
    80003b7a:	e85a                	sd	s6,16(sp)
    80003b7c:	e45e                	sd	s7,8(sp)
    80003b7e:	e062                	sd	s8,0(sp)
    80003b80:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b82:	00954783          	lbu	a5,9(a0)
    80003b86:	10078663          	beqz	a5,80003c92 <filewrite+0x128>
    80003b8a:	892a                	mv	s2,a0
    80003b8c:	8aae                	mv	s5,a1
    80003b8e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b90:	411c                	lw	a5,0(a0)
    80003b92:	4705                	li	a4,1
    80003b94:	02e78263          	beq	a5,a4,80003bb8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b98:	470d                	li	a4,3
    80003b9a:	02e78663          	beq	a5,a4,80003bc6 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b9e:	4709                	li	a4,2
    80003ba0:	0ee79163          	bne	a5,a4,80003c82 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ba4:	0ac05d63          	blez	a2,80003c5e <filewrite+0xf4>
    int i = 0;
    80003ba8:	4981                	li	s3,0
    80003baa:	6b05                	lui	s6,0x1
    80003bac:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003bb0:	6b85                	lui	s7,0x1
    80003bb2:	c00b8b9b          	addiw	s7,s7,-1024
    80003bb6:	a861                	j	80003c4e <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bb8:	6908                	ld	a0,16(a0)
    80003bba:	00000097          	auipc	ra,0x0
    80003bbe:	22e080e7          	jalr	558(ra) # 80003de8 <pipewrite>
    80003bc2:	8a2a                	mv	s4,a0
    80003bc4:	a045                	j	80003c64 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bc6:	02451783          	lh	a5,36(a0)
    80003bca:	03079693          	slli	a3,a5,0x30
    80003bce:	92c1                	srli	a3,a3,0x30
    80003bd0:	4725                	li	a4,9
    80003bd2:	0cd76263          	bltu	a4,a3,80003c96 <filewrite+0x12c>
    80003bd6:	0792                	slli	a5,a5,0x4
    80003bd8:	00015717          	auipc	a4,0x15
    80003bdc:	d8070713          	addi	a4,a4,-640 # 80018958 <devsw>
    80003be0:	97ba                	add	a5,a5,a4
    80003be2:	679c                	ld	a5,8(a5)
    80003be4:	cbdd                	beqz	a5,80003c9a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003be6:	4505                	li	a0,1
    80003be8:	9782                	jalr	a5
    80003bea:	8a2a                	mv	s4,a0
    80003bec:	a8a5                	j	80003c64 <filewrite+0xfa>
    80003bee:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003bf2:	00000097          	auipc	ra,0x0
    80003bf6:	8b0080e7          	jalr	-1872(ra) # 800034a2 <begin_op>
      ilock(f->ip);
    80003bfa:	01893503          	ld	a0,24(s2)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	ee2080e7          	jalr	-286(ra) # 80002ae0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c06:	8762                	mv	a4,s8
    80003c08:	02092683          	lw	a3,32(s2)
    80003c0c:	01598633          	add	a2,s3,s5
    80003c10:	4585                	li	a1,1
    80003c12:	01893503          	ld	a0,24(s2)
    80003c16:	fffff097          	auipc	ra,0xfffff
    80003c1a:	276080e7          	jalr	630(ra) # 80002e8c <writei>
    80003c1e:	84aa                	mv	s1,a0
    80003c20:	00a05763          	blez	a0,80003c2e <filewrite+0xc4>
        f->off += r;
    80003c24:	02092783          	lw	a5,32(s2)
    80003c28:	9fa9                	addw	a5,a5,a0
    80003c2a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c2e:	01893503          	ld	a0,24(s2)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	f70080e7          	jalr	-144(ra) # 80002ba2 <iunlock>
      end_op();
    80003c3a:	00000097          	auipc	ra,0x0
    80003c3e:	8e8080e7          	jalr	-1816(ra) # 80003522 <end_op>

      if(r != n1){
    80003c42:	009c1f63          	bne	s8,s1,80003c60 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c46:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c4a:	0149db63          	bge	s3,s4,80003c60 <filewrite+0xf6>
      int n1 = n - i;
    80003c4e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003c52:	84be                	mv	s1,a5
    80003c54:	2781                	sext.w	a5,a5
    80003c56:	f8fb5ce3          	bge	s6,a5,80003bee <filewrite+0x84>
    80003c5a:	84de                	mv	s1,s7
    80003c5c:	bf49                	j	80003bee <filewrite+0x84>
    int i = 0;
    80003c5e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c60:	013a1f63          	bne	s4,s3,80003c7e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c64:	8552                	mv	a0,s4
    80003c66:	60a6                	ld	ra,72(sp)
    80003c68:	6406                	ld	s0,64(sp)
    80003c6a:	74e2                	ld	s1,56(sp)
    80003c6c:	7942                	ld	s2,48(sp)
    80003c6e:	79a2                	ld	s3,40(sp)
    80003c70:	7a02                	ld	s4,32(sp)
    80003c72:	6ae2                	ld	s5,24(sp)
    80003c74:	6b42                	ld	s6,16(sp)
    80003c76:	6ba2                	ld	s7,8(sp)
    80003c78:	6c02                	ld	s8,0(sp)
    80003c7a:	6161                	addi	sp,sp,80
    80003c7c:	8082                	ret
    ret = (i == n ? n : -1);
    80003c7e:	5a7d                	li	s4,-1
    80003c80:	b7d5                	j	80003c64 <filewrite+0xfa>
    panic("filewrite");
    80003c82:	00005517          	auipc	a0,0x5
    80003c86:	9b650513          	addi	a0,a0,-1610 # 80008638 <syscalls+0x268>
    80003c8a:	00002097          	auipc	ra,0x2
    80003c8e:	f04080e7          	jalr	-252(ra) # 80005b8e <panic>
    return -1;
    80003c92:	5a7d                	li	s4,-1
    80003c94:	bfc1                	j	80003c64 <filewrite+0xfa>
      return -1;
    80003c96:	5a7d                	li	s4,-1
    80003c98:	b7f1                	j	80003c64 <filewrite+0xfa>
    80003c9a:	5a7d                	li	s4,-1
    80003c9c:	b7e1                	j	80003c64 <filewrite+0xfa>

0000000080003c9e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c9e:	7179                	addi	sp,sp,-48
    80003ca0:	f406                	sd	ra,40(sp)
    80003ca2:	f022                	sd	s0,32(sp)
    80003ca4:	ec26                	sd	s1,24(sp)
    80003ca6:	e84a                	sd	s2,16(sp)
    80003ca8:	e44e                	sd	s3,8(sp)
    80003caa:	e052                	sd	s4,0(sp)
    80003cac:	1800                	addi	s0,sp,48
    80003cae:	84aa                	mv	s1,a0
    80003cb0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cb2:	0005b023          	sd	zero,0(a1)
    80003cb6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cba:	00000097          	auipc	ra,0x0
    80003cbe:	bf8080e7          	jalr	-1032(ra) # 800038b2 <filealloc>
    80003cc2:	e088                	sd	a0,0(s1)
    80003cc4:	c551                	beqz	a0,80003d50 <pipealloc+0xb2>
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	bec080e7          	jalr	-1044(ra) # 800038b2 <filealloc>
    80003cce:	00aa3023          	sd	a0,0(s4)
    80003cd2:	c92d                	beqz	a0,80003d44 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cd4:	ffffc097          	auipc	ra,0xffffc
    80003cd8:	444080e7          	jalr	1092(ra) # 80000118 <kalloc>
    80003cdc:	892a                	mv	s2,a0
    80003cde:	c125                	beqz	a0,80003d3e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ce0:	4985                	li	s3,1
    80003ce2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ce6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cea:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cee:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cf2:	00005597          	auipc	a1,0x5
    80003cf6:	95658593          	addi	a1,a1,-1706 # 80008648 <syscalls+0x278>
    80003cfa:	00002097          	auipc	ra,0x2
    80003cfe:	340080e7          	jalr	832(ra) # 8000603a <initlock>
  (*f0)->type = FD_PIPE;
    80003d02:	609c                	ld	a5,0(s1)
    80003d04:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d08:	609c                	ld	a5,0(s1)
    80003d0a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d0e:	609c                	ld	a5,0(s1)
    80003d10:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d14:	609c                	ld	a5,0(s1)
    80003d16:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d1a:	000a3783          	ld	a5,0(s4)
    80003d1e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d22:	000a3783          	ld	a5,0(s4)
    80003d26:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d2a:	000a3783          	ld	a5,0(s4)
    80003d2e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d32:	000a3783          	ld	a5,0(s4)
    80003d36:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d3a:	4501                	li	a0,0
    80003d3c:	a025                	j	80003d64 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d3e:	6088                	ld	a0,0(s1)
    80003d40:	e501                	bnez	a0,80003d48 <pipealloc+0xaa>
    80003d42:	a039                	j	80003d50 <pipealloc+0xb2>
    80003d44:	6088                	ld	a0,0(s1)
    80003d46:	c51d                	beqz	a0,80003d74 <pipealloc+0xd6>
    fileclose(*f0);
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	c26080e7          	jalr	-986(ra) # 8000396e <fileclose>
  if(*f1)
    80003d50:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d54:	557d                	li	a0,-1
  if(*f1)
    80003d56:	c799                	beqz	a5,80003d64 <pipealloc+0xc6>
    fileclose(*f1);
    80003d58:	853e                	mv	a0,a5
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	c14080e7          	jalr	-1004(ra) # 8000396e <fileclose>
  return -1;
    80003d62:	557d                	li	a0,-1
}
    80003d64:	70a2                	ld	ra,40(sp)
    80003d66:	7402                	ld	s0,32(sp)
    80003d68:	64e2                	ld	s1,24(sp)
    80003d6a:	6942                	ld	s2,16(sp)
    80003d6c:	69a2                	ld	s3,8(sp)
    80003d6e:	6a02                	ld	s4,0(sp)
    80003d70:	6145                	addi	sp,sp,48
    80003d72:	8082                	ret
  return -1;
    80003d74:	557d                	li	a0,-1
    80003d76:	b7fd                	j	80003d64 <pipealloc+0xc6>

0000000080003d78 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d78:	1101                	addi	sp,sp,-32
    80003d7a:	ec06                	sd	ra,24(sp)
    80003d7c:	e822                	sd	s0,16(sp)
    80003d7e:	e426                	sd	s1,8(sp)
    80003d80:	e04a                	sd	s2,0(sp)
    80003d82:	1000                	addi	s0,sp,32
    80003d84:	84aa                	mv	s1,a0
    80003d86:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d88:	00002097          	auipc	ra,0x2
    80003d8c:	342080e7          	jalr	834(ra) # 800060ca <acquire>
  if(writable){
    80003d90:	02090d63          	beqz	s2,80003dca <pipeclose+0x52>
    pi->writeopen = 0;
    80003d94:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d98:	21848513          	addi	a0,s1,536
    80003d9c:	ffffd097          	auipc	ra,0xffffd
    80003da0:	7c2080e7          	jalr	1986(ra) # 8000155e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003da4:	2204b783          	ld	a5,544(s1)
    80003da8:	eb95                	bnez	a5,80003ddc <pipeclose+0x64>
    release(&pi->lock);
    80003daa:	8526                	mv	a0,s1
    80003dac:	00002097          	auipc	ra,0x2
    80003db0:	3d2080e7          	jalr	978(ra) # 8000617e <release>
    kfree((char*)pi);
    80003db4:	8526                	mv	a0,s1
    80003db6:	ffffc097          	auipc	ra,0xffffc
    80003dba:	266080e7          	jalr	614(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dbe:	60e2                	ld	ra,24(sp)
    80003dc0:	6442                	ld	s0,16(sp)
    80003dc2:	64a2                	ld	s1,8(sp)
    80003dc4:	6902                	ld	s2,0(sp)
    80003dc6:	6105                	addi	sp,sp,32
    80003dc8:	8082                	ret
    pi->readopen = 0;
    80003dca:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dce:	21c48513          	addi	a0,s1,540
    80003dd2:	ffffd097          	auipc	ra,0xffffd
    80003dd6:	78c080e7          	jalr	1932(ra) # 8000155e <wakeup>
    80003dda:	b7e9                	j	80003da4 <pipeclose+0x2c>
    release(&pi->lock);
    80003ddc:	8526                	mv	a0,s1
    80003dde:	00002097          	auipc	ra,0x2
    80003de2:	3a0080e7          	jalr	928(ra) # 8000617e <release>
}
    80003de6:	bfe1                	j	80003dbe <pipeclose+0x46>

0000000080003de8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003de8:	711d                	addi	sp,sp,-96
    80003dea:	ec86                	sd	ra,88(sp)
    80003dec:	e8a2                	sd	s0,80(sp)
    80003dee:	e4a6                	sd	s1,72(sp)
    80003df0:	e0ca                	sd	s2,64(sp)
    80003df2:	fc4e                	sd	s3,56(sp)
    80003df4:	f852                	sd	s4,48(sp)
    80003df6:	f456                	sd	s5,40(sp)
    80003df8:	f05a                	sd	s6,32(sp)
    80003dfa:	ec5e                	sd	s7,24(sp)
    80003dfc:	e862                	sd	s8,16(sp)
    80003dfe:	1080                	addi	s0,sp,96
    80003e00:	84aa                	mv	s1,a0
    80003e02:	8aae                	mv	s5,a1
    80003e04:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e06:	ffffd097          	auipc	ra,0xffffd
    80003e0a:	04c080e7          	jalr	76(ra) # 80000e52 <myproc>
    80003e0e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e10:	8526                	mv	a0,s1
    80003e12:	00002097          	auipc	ra,0x2
    80003e16:	2b8080e7          	jalr	696(ra) # 800060ca <acquire>
  while(i < n){
    80003e1a:	0b405663          	blez	s4,80003ec6 <pipewrite+0xde>
  int i = 0;
    80003e1e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e20:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e22:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e26:	21c48b93          	addi	s7,s1,540
    80003e2a:	a089                	j	80003e6c <pipewrite+0x84>
      release(&pi->lock);
    80003e2c:	8526                	mv	a0,s1
    80003e2e:	00002097          	auipc	ra,0x2
    80003e32:	350080e7          	jalr	848(ra) # 8000617e <release>
      return -1;
    80003e36:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e38:	854a                	mv	a0,s2
    80003e3a:	60e6                	ld	ra,88(sp)
    80003e3c:	6446                	ld	s0,80(sp)
    80003e3e:	64a6                	ld	s1,72(sp)
    80003e40:	6906                	ld	s2,64(sp)
    80003e42:	79e2                	ld	s3,56(sp)
    80003e44:	7a42                	ld	s4,48(sp)
    80003e46:	7aa2                	ld	s5,40(sp)
    80003e48:	7b02                	ld	s6,32(sp)
    80003e4a:	6be2                	ld	s7,24(sp)
    80003e4c:	6c42                	ld	s8,16(sp)
    80003e4e:	6125                	addi	sp,sp,96
    80003e50:	8082                	ret
      wakeup(&pi->nread);
    80003e52:	8562                	mv	a0,s8
    80003e54:	ffffd097          	auipc	ra,0xffffd
    80003e58:	70a080e7          	jalr	1802(ra) # 8000155e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e5c:	85a6                	mv	a1,s1
    80003e5e:	855e                	mv	a0,s7
    80003e60:	ffffd097          	auipc	ra,0xffffd
    80003e64:	69a080e7          	jalr	1690(ra) # 800014fa <sleep>
  while(i < n){
    80003e68:	07495063          	bge	s2,s4,80003ec8 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003e6c:	2204a783          	lw	a5,544(s1)
    80003e70:	dfd5                	beqz	a5,80003e2c <pipewrite+0x44>
    80003e72:	854e                	mv	a0,s3
    80003e74:	ffffe097          	auipc	ra,0xffffe
    80003e78:	92e080e7          	jalr	-1746(ra) # 800017a2 <killed>
    80003e7c:	f945                	bnez	a0,80003e2c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e7e:	2184a783          	lw	a5,536(s1)
    80003e82:	21c4a703          	lw	a4,540(s1)
    80003e86:	2007879b          	addiw	a5,a5,512
    80003e8a:	fcf704e3          	beq	a4,a5,80003e52 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e8e:	4685                	li	a3,1
    80003e90:	01590633          	add	a2,s2,s5
    80003e94:	faf40593          	addi	a1,s0,-81
    80003e98:	0509b503          	ld	a0,80(s3)
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	cfe080e7          	jalr	-770(ra) # 80000b9a <copyin>
    80003ea4:	03650263          	beq	a0,s6,80003ec8 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ea8:	21c4a783          	lw	a5,540(s1)
    80003eac:	0017871b          	addiw	a4,a5,1
    80003eb0:	20e4ae23          	sw	a4,540(s1)
    80003eb4:	1ff7f793          	andi	a5,a5,511
    80003eb8:	97a6                	add	a5,a5,s1
    80003eba:	faf44703          	lbu	a4,-81(s0)
    80003ebe:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ec2:	2905                	addiw	s2,s2,1
    80003ec4:	b755                	j	80003e68 <pipewrite+0x80>
  int i = 0;
    80003ec6:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ec8:	21848513          	addi	a0,s1,536
    80003ecc:	ffffd097          	auipc	ra,0xffffd
    80003ed0:	692080e7          	jalr	1682(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	00002097          	auipc	ra,0x2
    80003eda:	2a8080e7          	jalr	680(ra) # 8000617e <release>
  return i;
    80003ede:	bfa9                	j	80003e38 <pipewrite+0x50>

0000000080003ee0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ee0:	715d                	addi	sp,sp,-80
    80003ee2:	e486                	sd	ra,72(sp)
    80003ee4:	e0a2                	sd	s0,64(sp)
    80003ee6:	fc26                	sd	s1,56(sp)
    80003ee8:	f84a                	sd	s2,48(sp)
    80003eea:	f44e                	sd	s3,40(sp)
    80003eec:	f052                	sd	s4,32(sp)
    80003eee:	ec56                	sd	s5,24(sp)
    80003ef0:	e85a                	sd	s6,16(sp)
    80003ef2:	0880                	addi	s0,sp,80
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	892e                	mv	s2,a1
    80003ef8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	f58080e7          	jalr	-168(ra) # 80000e52 <myproc>
    80003f02:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	1c4080e7          	jalr	452(ra) # 800060ca <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f0e:	2184a703          	lw	a4,536(s1)
    80003f12:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f16:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f1a:	02f71763          	bne	a4,a5,80003f48 <piperead+0x68>
    80003f1e:	2244a783          	lw	a5,548(s1)
    80003f22:	c39d                	beqz	a5,80003f48 <piperead+0x68>
    if(killed(pr)){
    80003f24:	8552                	mv	a0,s4
    80003f26:	ffffe097          	auipc	ra,0xffffe
    80003f2a:	87c080e7          	jalr	-1924(ra) # 800017a2 <killed>
    80003f2e:	e941                	bnez	a0,80003fbe <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f30:	85a6                	mv	a1,s1
    80003f32:	854e                	mv	a0,s3
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	5c6080e7          	jalr	1478(ra) # 800014fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f3c:	2184a703          	lw	a4,536(s1)
    80003f40:	21c4a783          	lw	a5,540(s1)
    80003f44:	fcf70de3          	beq	a4,a5,80003f1e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f48:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f4a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f4c:	05505363          	blez	s5,80003f92 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003f50:	2184a783          	lw	a5,536(s1)
    80003f54:	21c4a703          	lw	a4,540(s1)
    80003f58:	02f70d63          	beq	a4,a5,80003f92 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f5c:	0017871b          	addiw	a4,a5,1
    80003f60:	20e4ac23          	sw	a4,536(s1)
    80003f64:	1ff7f793          	andi	a5,a5,511
    80003f68:	97a6                	add	a5,a5,s1
    80003f6a:	0187c783          	lbu	a5,24(a5)
    80003f6e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f72:	4685                	li	a3,1
    80003f74:	fbf40613          	addi	a2,s0,-65
    80003f78:	85ca                	mv	a1,s2
    80003f7a:	050a3503          	ld	a0,80(s4)
    80003f7e:	ffffd097          	auipc	ra,0xffffd
    80003f82:	b90080e7          	jalr	-1136(ra) # 80000b0e <copyout>
    80003f86:	01650663          	beq	a0,s6,80003f92 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f8a:	2985                	addiw	s3,s3,1
    80003f8c:	0905                	addi	s2,s2,1
    80003f8e:	fd3a91e3          	bne	s5,s3,80003f50 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f92:	21c48513          	addi	a0,s1,540
    80003f96:	ffffd097          	auipc	ra,0xffffd
    80003f9a:	5c8080e7          	jalr	1480(ra) # 8000155e <wakeup>
  release(&pi->lock);
    80003f9e:	8526                	mv	a0,s1
    80003fa0:	00002097          	auipc	ra,0x2
    80003fa4:	1de080e7          	jalr	478(ra) # 8000617e <release>
  return i;
}
    80003fa8:	854e                	mv	a0,s3
    80003faa:	60a6                	ld	ra,72(sp)
    80003fac:	6406                	ld	s0,64(sp)
    80003fae:	74e2                	ld	s1,56(sp)
    80003fb0:	7942                	ld	s2,48(sp)
    80003fb2:	79a2                	ld	s3,40(sp)
    80003fb4:	7a02                	ld	s4,32(sp)
    80003fb6:	6ae2                	ld	s5,24(sp)
    80003fb8:	6b42                	ld	s6,16(sp)
    80003fba:	6161                	addi	sp,sp,80
    80003fbc:	8082                	ret
      release(&pi->lock);
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	00002097          	auipc	ra,0x2
    80003fc4:	1be080e7          	jalr	446(ra) # 8000617e <release>
      return -1;
    80003fc8:	59fd                	li	s3,-1
    80003fca:	bff9                	j	80003fa8 <piperead+0xc8>

0000000080003fcc <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fcc:	1141                	addi	sp,sp,-16
    80003fce:	e422                	sd	s0,8(sp)
    80003fd0:	0800                	addi	s0,sp,16
    80003fd2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fd4:	8905                	andi	a0,a0,1
    80003fd6:	c111                	beqz	a0,80003fda <flags2perm+0xe>
      perm = PTE_X;
    80003fd8:	4521                	li	a0,8
    if(flags & 0x2)
    80003fda:	8b89                	andi	a5,a5,2
    80003fdc:	c399                	beqz	a5,80003fe2 <flags2perm+0x16>
      perm |= PTE_W;
    80003fde:	00456513          	ori	a0,a0,4
    return perm;
}
    80003fe2:	6422                	ld	s0,8(sp)
    80003fe4:	0141                	addi	sp,sp,16
    80003fe6:	8082                	ret

0000000080003fe8 <exec>:

int
exec(char *path, char **argv)
{
    80003fe8:	de010113          	addi	sp,sp,-544
    80003fec:	20113c23          	sd	ra,536(sp)
    80003ff0:	20813823          	sd	s0,528(sp)
    80003ff4:	20913423          	sd	s1,520(sp)
    80003ff8:	21213023          	sd	s2,512(sp)
    80003ffc:	ffce                	sd	s3,504(sp)
    80003ffe:	fbd2                	sd	s4,496(sp)
    80004000:	f7d6                	sd	s5,488(sp)
    80004002:	f3da                	sd	s6,480(sp)
    80004004:	efde                	sd	s7,472(sp)
    80004006:	ebe2                	sd	s8,464(sp)
    80004008:	e7e6                	sd	s9,456(sp)
    8000400a:	e3ea                	sd	s10,448(sp)
    8000400c:	ff6e                	sd	s11,440(sp)
    8000400e:	1400                	addi	s0,sp,544
    80004010:	892a                	mv	s2,a0
    80004012:	dea43423          	sd	a0,-536(s0)
    80004016:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000401a:	ffffd097          	auipc	ra,0xffffd
    8000401e:	e38080e7          	jalr	-456(ra) # 80000e52 <myproc>
    80004022:	84aa                	mv	s1,a0

  begin_op();
    80004024:	fffff097          	auipc	ra,0xfffff
    80004028:	47e080e7          	jalr	1150(ra) # 800034a2 <begin_op>

  if((ip = namei(path)) == 0){
    8000402c:	854a                	mv	a0,s2
    8000402e:	fffff097          	auipc	ra,0xfffff
    80004032:	258080e7          	jalr	600(ra) # 80003286 <namei>
    80004036:	c93d                	beqz	a0,800040ac <exec+0xc4>
    80004038:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000403a:	fffff097          	auipc	ra,0xfffff
    8000403e:	aa6080e7          	jalr	-1370(ra) # 80002ae0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004042:	04000713          	li	a4,64
    80004046:	4681                	li	a3,0
    80004048:	e5040613          	addi	a2,s0,-432
    8000404c:	4581                	li	a1,0
    8000404e:	8556                	mv	a0,s5
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	d44080e7          	jalr	-700(ra) # 80002d94 <readi>
    80004058:	04000793          	li	a5,64
    8000405c:	00f51a63          	bne	a0,a5,80004070 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004060:	e5042703          	lw	a4,-432(s0)
    80004064:	464c47b7          	lui	a5,0x464c4
    80004068:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000406c:	04f70663          	beq	a4,a5,800040b8 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004070:	8556                	mv	a0,s5
    80004072:	fffff097          	auipc	ra,0xfffff
    80004076:	cd0080e7          	jalr	-816(ra) # 80002d42 <iunlockput>
    end_op();
    8000407a:	fffff097          	auipc	ra,0xfffff
    8000407e:	4a8080e7          	jalr	1192(ra) # 80003522 <end_op>
  }
  return -1;
    80004082:	557d                	li	a0,-1
}
    80004084:	21813083          	ld	ra,536(sp)
    80004088:	21013403          	ld	s0,528(sp)
    8000408c:	20813483          	ld	s1,520(sp)
    80004090:	20013903          	ld	s2,512(sp)
    80004094:	79fe                	ld	s3,504(sp)
    80004096:	7a5e                	ld	s4,496(sp)
    80004098:	7abe                	ld	s5,488(sp)
    8000409a:	7b1e                	ld	s6,480(sp)
    8000409c:	6bfe                	ld	s7,472(sp)
    8000409e:	6c5e                	ld	s8,464(sp)
    800040a0:	6cbe                	ld	s9,456(sp)
    800040a2:	6d1e                	ld	s10,448(sp)
    800040a4:	7dfa                	ld	s11,440(sp)
    800040a6:	22010113          	addi	sp,sp,544
    800040aa:	8082                	ret
    end_op();
    800040ac:	fffff097          	auipc	ra,0xfffff
    800040b0:	476080e7          	jalr	1142(ra) # 80003522 <end_op>
    return -1;
    800040b4:	557d                	li	a0,-1
    800040b6:	b7f9                	j	80004084 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040b8:	8526                	mv	a0,s1
    800040ba:	ffffd097          	auipc	ra,0xffffd
    800040be:	e5c080e7          	jalr	-420(ra) # 80000f16 <proc_pagetable>
    800040c2:	8b2a                	mv	s6,a0
    800040c4:	d555                	beqz	a0,80004070 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040c6:	e7042783          	lw	a5,-400(s0)
    800040ca:	e8845703          	lhu	a4,-376(s0)
    800040ce:	c735                	beqz	a4,8000413a <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040d0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040d2:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800040d6:	6a05                	lui	s4,0x1
    800040d8:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800040dc:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800040e0:	6d85                	lui	s11,0x1
    800040e2:	7d7d                	lui	s10,0xfffff
    800040e4:	a481                	j	80004324 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040e6:	00004517          	auipc	a0,0x4
    800040ea:	56a50513          	addi	a0,a0,1386 # 80008650 <syscalls+0x280>
    800040ee:	00002097          	auipc	ra,0x2
    800040f2:	aa0080e7          	jalr	-1376(ra) # 80005b8e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040f6:	874a                	mv	a4,s2
    800040f8:	009c86bb          	addw	a3,s9,s1
    800040fc:	4581                	li	a1,0
    800040fe:	8556                	mv	a0,s5
    80004100:	fffff097          	auipc	ra,0xfffff
    80004104:	c94080e7          	jalr	-876(ra) # 80002d94 <readi>
    80004108:	2501                	sext.w	a0,a0
    8000410a:	1aa91a63          	bne	s2,a0,800042be <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    8000410e:	009d84bb          	addw	s1,s11,s1
    80004112:	013d09bb          	addw	s3,s10,s3
    80004116:	1f74f763          	bgeu	s1,s7,80004304 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    8000411a:	02049593          	slli	a1,s1,0x20
    8000411e:	9181                	srli	a1,a1,0x20
    80004120:	95e2                	add	a1,a1,s8
    80004122:	855a                	mv	a0,s6
    80004124:	ffffc097          	auipc	ra,0xffffc
    80004128:	3de080e7          	jalr	990(ra) # 80000502 <walkaddr>
    8000412c:	862a                	mv	a2,a0
    if(pa == 0)
    8000412e:	dd45                	beqz	a0,800040e6 <exec+0xfe>
      n = PGSIZE;
    80004130:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004132:	fd49f2e3          	bgeu	s3,s4,800040f6 <exec+0x10e>
      n = sz - i;
    80004136:	894e                	mv	s2,s3
    80004138:	bf7d                	j	800040f6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000413a:	4901                	li	s2,0
  iunlockput(ip);
    8000413c:	8556                	mv	a0,s5
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	c04080e7          	jalr	-1020(ra) # 80002d42 <iunlockput>
  end_op();
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	3dc080e7          	jalr	988(ra) # 80003522 <end_op>
  p = myproc();
    8000414e:	ffffd097          	auipc	ra,0xffffd
    80004152:	d04080e7          	jalr	-764(ra) # 80000e52 <myproc>
    80004156:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004158:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000415c:	6785                	lui	a5,0x1
    8000415e:	17fd                	addi	a5,a5,-1
    80004160:	993e                	add	s2,s2,a5
    80004162:	77fd                	lui	a5,0xfffff
    80004164:	00f977b3          	and	a5,s2,a5
    80004168:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000416c:	4691                	li	a3,4
    8000416e:	6609                	lui	a2,0x2
    80004170:	963e                	add	a2,a2,a5
    80004172:	85be                	mv	a1,a5
    80004174:	855a                	mv	a0,s6
    80004176:	ffffc097          	auipc	ra,0xffffc
    8000417a:	740080e7          	jalr	1856(ra) # 800008b6 <uvmalloc>
    8000417e:	8c2a                	mv	s8,a0
  ip = 0;
    80004180:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004182:	12050e63          	beqz	a0,800042be <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004186:	75f9                	lui	a1,0xffffe
    80004188:	95aa                	add	a1,a1,a0
    8000418a:	855a                	mv	a0,s6
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	950080e7          	jalr	-1712(ra) # 80000adc <uvmclear>
  stackbase = sp - PGSIZE;
    80004194:	7afd                	lui	s5,0xfffff
    80004196:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004198:	df043783          	ld	a5,-528(s0)
    8000419c:	6388                	ld	a0,0(a5)
    8000419e:	c925                	beqz	a0,8000420e <exec+0x226>
    800041a0:	e9040993          	addi	s3,s0,-368
    800041a4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041a8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041aa:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800041ac:	ffffc097          	auipc	ra,0xffffc
    800041b0:	148080e7          	jalr	328(ra) # 800002f4 <strlen>
    800041b4:	0015079b          	addiw	a5,a0,1
    800041b8:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041bc:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041c0:	13596663          	bltu	s2,s5,800042ec <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041c4:	df043d83          	ld	s11,-528(s0)
    800041c8:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041cc:	8552                	mv	a0,s4
    800041ce:	ffffc097          	auipc	ra,0xffffc
    800041d2:	126080e7          	jalr	294(ra) # 800002f4 <strlen>
    800041d6:	0015069b          	addiw	a3,a0,1
    800041da:	8652                	mv	a2,s4
    800041dc:	85ca                	mv	a1,s2
    800041de:	855a                	mv	a0,s6
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	92e080e7          	jalr	-1746(ra) # 80000b0e <copyout>
    800041e8:	10054663          	bltz	a0,800042f4 <exec+0x30c>
    ustack[argc] = sp;
    800041ec:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041f0:	0485                	addi	s1,s1,1
    800041f2:	008d8793          	addi	a5,s11,8
    800041f6:	def43823          	sd	a5,-528(s0)
    800041fa:	008db503          	ld	a0,8(s11)
    800041fe:	c911                	beqz	a0,80004212 <exec+0x22a>
    if(argc >= MAXARG)
    80004200:	09a1                	addi	s3,s3,8
    80004202:	fb3c95e3          	bne	s9,s3,800041ac <exec+0x1c4>
  sz = sz1;
    80004206:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000420a:	4a81                	li	s5,0
    8000420c:	a84d                	j	800042be <exec+0x2d6>
  sp = sz;
    8000420e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004210:	4481                	li	s1,0
  ustack[argc] = 0;
    80004212:	00349793          	slli	a5,s1,0x3
    80004216:	f9040713          	addi	a4,s0,-112
    8000421a:	97ba                	add	a5,a5,a4
    8000421c:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdd1d0>
  sp -= (argc+1) * sizeof(uint64);
    80004220:	00148693          	addi	a3,s1,1
    80004224:	068e                	slli	a3,a3,0x3
    80004226:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000422a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000422e:	01597663          	bgeu	s2,s5,8000423a <exec+0x252>
  sz = sz1;
    80004232:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004236:	4a81                	li	s5,0
    80004238:	a059                	j	800042be <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000423a:	e9040613          	addi	a2,s0,-368
    8000423e:	85ca                	mv	a1,s2
    80004240:	855a                	mv	a0,s6
    80004242:	ffffd097          	auipc	ra,0xffffd
    80004246:	8cc080e7          	jalr	-1844(ra) # 80000b0e <copyout>
    8000424a:	0a054963          	bltz	a0,800042fc <exec+0x314>
  p->trapframe->a1 = sp;
    8000424e:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004252:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004256:	de843783          	ld	a5,-536(s0)
    8000425a:	0007c703          	lbu	a4,0(a5)
    8000425e:	cf11                	beqz	a4,8000427a <exec+0x292>
    80004260:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004262:	02f00693          	li	a3,47
    80004266:	a039                	j	80004274 <exec+0x28c>
      last = s+1;
    80004268:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000426c:	0785                	addi	a5,a5,1
    8000426e:	fff7c703          	lbu	a4,-1(a5)
    80004272:	c701                	beqz	a4,8000427a <exec+0x292>
    if(*s == '/')
    80004274:	fed71ce3          	bne	a4,a3,8000426c <exec+0x284>
    80004278:	bfc5                	j	80004268 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    8000427a:	4641                	li	a2,16
    8000427c:	de843583          	ld	a1,-536(s0)
    80004280:	158b8513          	addi	a0,s7,344
    80004284:	ffffc097          	auipc	ra,0xffffc
    80004288:	03e080e7          	jalr	62(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000428c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004290:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004294:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004298:	058bb783          	ld	a5,88(s7)
    8000429c:	e6843703          	ld	a4,-408(s0)
    800042a0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042a2:	058bb783          	ld	a5,88(s7)
    800042a6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042aa:	85ea                	mv	a1,s10
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	d06080e7          	jalr	-762(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042b4:	0004851b          	sext.w	a0,s1
    800042b8:	b3f1                	j	80004084 <exec+0x9c>
    800042ba:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042be:	df843583          	ld	a1,-520(s0)
    800042c2:	855a                	mv	a0,s6
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	cee080e7          	jalr	-786(ra) # 80000fb2 <proc_freepagetable>
  if(ip){
    800042cc:	da0a92e3          	bnez	s5,80004070 <exec+0x88>
  return -1;
    800042d0:	557d                	li	a0,-1
    800042d2:	bb4d                	j	80004084 <exec+0x9c>
    800042d4:	df243c23          	sd	s2,-520(s0)
    800042d8:	b7dd                	j	800042be <exec+0x2d6>
    800042da:	df243c23          	sd	s2,-520(s0)
    800042de:	b7c5                	j	800042be <exec+0x2d6>
    800042e0:	df243c23          	sd	s2,-520(s0)
    800042e4:	bfe9                	j	800042be <exec+0x2d6>
    800042e6:	df243c23          	sd	s2,-520(s0)
    800042ea:	bfd1                	j	800042be <exec+0x2d6>
  sz = sz1;
    800042ec:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f0:	4a81                	li	s5,0
    800042f2:	b7f1                	j	800042be <exec+0x2d6>
  sz = sz1;
    800042f4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f8:	4a81                	li	s5,0
    800042fa:	b7d1                	j	800042be <exec+0x2d6>
  sz = sz1;
    800042fc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004300:	4a81                	li	s5,0
    80004302:	bf75                	j	800042be <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004304:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004308:	e0843783          	ld	a5,-504(s0)
    8000430c:	0017869b          	addiw	a3,a5,1
    80004310:	e0d43423          	sd	a3,-504(s0)
    80004314:	e0043783          	ld	a5,-512(s0)
    80004318:	0387879b          	addiw	a5,a5,56
    8000431c:	e8845703          	lhu	a4,-376(s0)
    80004320:	e0e6dee3          	bge	a3,a4,8000413c <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004324:	2781                	sext.w	a5,a5
    80004326:	e0f43023          	sd	a5,-512(s0)
    8000432a:	03800713          	li	a4,56
    8000432e:	86be                	mv	a3,a5
    80004330:	e1840613          	addi	a2,s0,-488
    80004334:	4581                	li	a1,0
    80004336:	8556                	mv	a0,s5
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	a5c080e7          	jalr	-1444(ra) # 80002d94 <readi>
    80004340:	03800793          	li	a5,56
    80004344:	f6f51be3          	bne	a0,a5,800042ba <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80004348:	e1842783          	lw	a5,-488(s0)
    8000434c:	4705                	li	a4,1
    8000434e:	fae79de3          	bne	a5,a4,80004308 <exec+0x320>
    if(ph.memsz < ph.filesz)
    80004352:	e4043483          	ld	s1,-448(s0)
    80004356:	e3843783          	ld	a5,-456(s0)
    8000435a:	f6f4ede3          	bltu	s1,a5,800042d4 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000435e:	e2843783          	ld	a5,-472(s0)
    80004362:	94be                	add	s1,s1,a5
    80004364:	f6f4ebe3          	bltu	s1,a5,800042da <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80004368:	de043703          	ld	a4,-544(s0)
    8000436c:	8ff9                	and	a5,a5,a4
    8000436e:	fbad                	bnez	a5,800042e0 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004370:	e1c42503          	lw	a0,-484(s0)
    80004374:	00000097          	auipc	ra,0x0
    80004378:	c58080e7          	jalr	-936(ra) # 80003fcc <flags2perm>
    8000437c:	86aa                	mv	a3,a0
    8000437e:	8626                	mv	a2,s1
    80004380:	85ca                	mv	a1,s2
    80004382:	855a                	mv	a0,s6
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	532080e7          	jalr	1330(ra) # 800008b6 <uvmalloc>
    8000438c:	dea43c23          	sd	a0,-520(s0)
    80004390:	d939                	beqz	a0,800042e6 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004392:	e2843c03          	ld	s8,-472(s0)
    80004396:	e2042c83          	lw	s9,-480(s0)
    8000439a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000439e:	f60b83e3          	beqz	s7,80004304 <exec+0x31c>
    800043a2:	89de                	mv	s3,s7
    800043a4:	4481                	li	s1,0
    800043a6:	bb95                	j	8000411a <exec+0x132>

00000000800043a8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043a8:	7179                	addi	sp,sp,-48
    800043aa:	f406                	sd	ra,40(sp)
    800043ac:	f022                	sd	s0,32(sp)
    800043ae:	ec26                	sd	s1,24(sp)
    800043b0:	e84a                	sd	s2,16(sp)
    800043b2:	1800                	addi	s0,sp,48
    800043b4:	892e                	mv	s2,a1
    800043b6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043b8:	fdc40593          	addi	a1,s0,-36
    800043bc:	ffffe097          	auipc	ra,0xffffe
    800043c0:	baa080e7          	jalr	-1110(ra) # 80001f66 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043c4:	fdc42703          	lw	a4,-36(s0)
    800043c8:	47bd                	li	a5,15
    800043ca:	02e7eb63          	bltu	a5,a4,80004400 <argfd+0x58>
    800043ce:	ffffd097          	auipc	ra,0xffffd
    800043d2:	a84080e7          	jalr	-1404(ra) # 80000e52 <myproc>
    800043d6:	fdc42703          	lw	a4,-36(s0)
    800043da:	01a70793          	addi	a5,a4,26
    800043de:	078e                	slli	a5,a5,0x3
    800043e0:	953e                	add	a0,a0,a5
    800043e2:	611c                	ld	a5,0(a0)
    800043e4:	c385                	beqz	a5,80004404 <argfd+0x5c>
    return -1;
  if(pfd)
    800043e6:	00090463          	beqz	s2,800043ee <argfd+0x46>
    *pfd = fd;
    800043ea:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043ee:	4501                	li	a0,0
  if(pf)
    800043f0:	c091                	beqz	s1,800043f4 <argfd+0x4c>
    *pf = f;
    800043f2:	e09c                	sd	a5,0(s1)
}
    800043f4:	70a2                	ld	ra,40(sp)
    800043f6:	7402                	ld	s0,32(sp)
    800043f8:	64e2                	ld	s1,24(sp)
    800043fa:	6942                	ld	s2,16(sp)
    800043fc:	6145                	addi	sp,sp,48
    800043fe:	8082                	ret
    return -1;
    80004400:	557d                	li	a0,-1
    80004402:	bfcd                	j	800043f4 <argfd+0x4c>
    80004404:	557d                	li	a0,-1
    80004406:	b7fd                	j	800043f4 <argfd+0x4c>

0000000080004408 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004408:	1101                	addi	sp,sp,-32
    8000440a:	ec06                	sd	ra,24(sp)
    8000440c:	e822                	sd	s0,16(sp)
    8000440e:	e426                	sd	s1,8(sp)
    80004410:	1000                	addi	s0,sp,32
    80004412:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004414:	ffffd097          	auipc	ra,0xffffd
    80004418:	a3e080e7          	jalr	-1474(ra) # 80000e52 <myproc>
    8000441c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000441e:	0d050793          	addi	a5,a0,208
    80004422:	4501                	li	a0,0
    80004424:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004426:	6398                	ld	a4,0(a5)
    80004428:	cb19                	beqz	a4,8000443e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000442a:	2505                	addiw	a0,a0,1
    8000442c:	07a1                	addi	a5,a5,8
    8000442e:	fed51ce3          	bne	a0,a3,80004426 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004432:	557d                	li	a0,-1
}
    80004434:	60e2                	ld	ra,24(sp)
    80004436:	6442                	ld	s0,16(sp)
    80004438:	64a2                	ld	s1,8(sp)
    8000443a:	6105                	addi	sp,sp,32
    8000443c:	8082                	ret
      p->ofile[fd] = f;
    8000443e:	01a50793          	addi	a5,a0,26
    80004442:	078e                	slli	a5,a5,0x3
    80004444:	963e                	add	a2,a2,a5
    80004446:	e204                	sd	s1,0(a2)
      return fd;
    80004448:	b7f5                	j	80004434 <fdalloc+0x2c>

000000008000444a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000444a:	715d                	addi	sp,sp,-80
    8000444c:	e486                	sd	ra,72(sp)
    8000444e:	e0a2                	sd	s0,64(sp)
    80004450:	fc26                	sd	s1,56(sp)
    80004452:	f84a                	sd	s2,48(sp)
    80004454:	f44e                	sd	s3,40(sp)
    80004456:	f052                	sd	s4,32(sp)
    80004458:	ec56                	sd	s5,24(sp)
    8000445a:	e85a                	sd	s6,16(sp)
    8000445c:	0880                	addi	s0,sp,80
    8000445e:	8b2e                	mv	s6,a1
    80004460:	89b2                	mv	s3,a2
    80004462:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004464:	fb040593          	addi	a1,s0,-80
    80004468:	fffff097          	auipc	ra,0xfffff
    8000446c:	e3c080e7          	jalr	-452(ra) # 800032a4 <nameiparent>
    80004470:	84aa                	mv	s1,a0
    80004472:	14050f63          	beqz	a0,800045d0 <create+0x186>
    return 0;

  ilock(dp);
    80004476:	ffffe097          	auipc	ra,0xffffe
    8000447a:	66a080e7          	jalr	1642(ra) # 80002ae0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000447e:	4601                	li	a2,0
    80004480:	fb040593          	addi	a1,s0,-80
    80004484:	8526                	mv	a0,s1
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	b3e080e7          	jalr	-1218(ra) # 80002fc4 <dirlookup>
    8000448e:	8aaa                	mv	s5,a0
    80004490:	c931                	beqz	a0,800044e4 <create+0x9a>
    iunlockput(dp);
    80004492:	8526                	mv	a0,s1
    80004494:	fffff097          	auipc	ra,0xfffff
    80004498:	8ae080e7          	jalr	-1874(ra) # 80002d42 <iunlockput>
    ilock(ip);
    8000449c:	8556                	mv	a0,s5
    8000449e:	ffffe097          	auipc	ra,0xffffe
    800044a2:	642080e7          	jalr	1602(ra) # 80002ae0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044a6:	000b059b          	sext.w	a1,s6
    800044aa:	4789                	li	a5,2
    800044ac:	02f59563          	bne	a1,a5,800044d6 <create+0x8c>
    800044b0:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd314>
    800044b4:	37f9                	addiw	a5,a5,-2
    800044b6:	17c2                	slli	a5,a5,0x30
    800044b8:	93c1                	srli	a5,a5,0x30
    800044ba:	4705                	li	a4,1
    800044bc:	00f76d63          	bltu	a4,a5,800044d6 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044c0:	8556                	mv	a0,s5
    800044c2:	60a6                	ld	ra,72(sp)
    800044c4:	6406                	ld	s0,64(sp)
    800044c6:	74e2                	ld	s1,56(sp)
    800044c8:	7942                	ld	s2,48(sp)
    800044ca:	79a2                	ld	s3,40(sp)
    800044cc:	7a02                	ld	s4,32(sp)
    800044ce:	6ae2                	ld	s5,24(sp)
    800044d0:	6b42                	ld	s6,16(sp)
    800044d2:	6161                	addi	sp,sp,80
    800044d4:	8082                	ret
    iunlockput(ip);
    800044d6:	8556                	mv	a0,s5
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	86a080e7          	jalr	-1942(ra) # 80002d42 <iunlockput>
    return 0;
    800044e0:	4a81                	li	s5,0
    800044e2:	bff9                	j	800044c0 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044e4:	85da                	mv	a1,s6
    800044e6:	4088                	lw	a0,0(s1)
    800044e8:	ffffe097          	auipc	ra,0xffffe
    800044ec:	45c080e7          	jalr	1116(ra) # 80002944 <ialloc>
    800044f0:	8a2a                	mv	s4,a0
    800044f2:	c539                	beqz	a0,80004540 <create+0xf6>
  ilock(ip);
    800044f4:	ffffe097          	auipc	ra,0xffffe
    800044f8:	5ec080e7          	jalr	1516(ra) # 80002ae0 <ilock>
  ip->major = major;
    800044fc:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004500:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004504:	4905                	li	s2,1
    80004506:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000450a:	8552                	mv	a0,s4
    8000450c:	ffffe097          	auipc	ra,0xffffe
    80004510:	50a080e7          	jalr	1290(ra) # 80002a16 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004514:	000b059b          	sext.w	a1,s6
    80004518:	03258b63          	beq	a1,s2,8000454e <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    8000451c:	004a2603          	lw	a2,4(s4)
    80004520:	fb040593          	addi	a1,s0,-80
    80004524:	8526                	mv	a0,s1
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	cae080e7          	jalr	-850(ra) # 800031d4 <dirlink>
    8000452e:	06054f63          	bltz	a0,800045ac <create+0x162>
  iunlockput(dp);
    80004532:	8526                	mv	a0,s1
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	80e080e7          	jalr	-2034(ra) # 80002d42 <iunlockput>
  return ip;
    8000453c:	8ad2                	mv	s5,s4
    8000453e:	b749                	j	800044c0 <create+0x76>
    iunlockput(dp);
    80004540:	8526                	mv	a0,s1
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	800080e7          	jalr	-2048(ra) # 80002d42 <iunlockput>
    return 0;
    8000454a:	8ad2                	mv	s5,s4
    8000454c:	bf95                	j	800044c0 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000454e:	004a2603          	lw	a2,4(s4)
    80004552:	00004597          	auipc	a1,0x4
    80004556:	11e58593          	addi	a1,a1,286 # 80008670 <syscalls+0x2a0>
    8000455a:	8552                	mv	a0,s4
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	c78080e7          	jalr	-904(ra) # 800031d4 <dirlink>
    80004564:	04054463          	bltz	a0,800045ac <create+0x162>
    80004568:	40d0                	lw	a2,4(s1)
    8000456a:	00004597          	auipc	a1,0x4
    8000456e:	10e58593          	addi	a1,a1,270 # 80008678 <syscalls+0x2a8>
    80004572:	8552                	mv	a0,s4
    80004574:	fffff097          	auipc	ra,0xfffff
    80004578:	c60080e7          	jalr	-928(ra) # 800031d4 <dirlink>
    8000457c:	02054863          	bltz	a0,800045ac <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004580:	004a2603          	lw	a2,4(s4)
    80004584:	fb040593          	addi	a1,s0,-80
    80004588:	8526                	mv	a0,s1
    8000458a:	fffff097          	auipc	ra,0xfffff
    8000458e:	c4a080e7          	jalr	-950(ra) # 800031d4 <dirlink>
    80004592:	00054d63          	bltz	a0,800045ac <create+0x162>
    dp->nlink++;  // for ".."
    80004596:	04a4d783          	lhu	a5,74(s1)
    8000459a:	2785                	addiw	a5,a5,1
    8000459c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045a0:	8526                	mv	a0,s1
    800045a2:	ffffe097          	auipc	ra,0xffffe
    800045a6:	474080e7          	jalr	1140(ra) # 80002a16 <iupdate>
    800045aa:	b761                	j	80004532 <create+0xe8>
  ip->nlink = 0;
    800045ac:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045b0:	8552                	mv	a0,s4
    800045b2:	ffffe097          	auipc	ra,0xffffe
    800045b6:	464080e7          	jalr	1124(ra) # 80002a16 <iupdate>
  iunlockput(ip);
    800045ba:	8552                	mv	a0,s4
    800045bc:	ffffe097          	auipc	ra,0xffffe
    800045c0:	786080e7          	jalr	1926(ra) # 80002d42 <iunlockput>
  iunlockput(dp);
    800045c4:	8526                	mv	a0,s1
    800045c6:	ffffe097          	auipc	ra,0xffffe
    800045ca:	77c080e7          	jalr	1916(ra) # 80002d42 <iunlockput>
  return 0;
    800045ce:	bdcd                	j	800044c0 <create+0x76>
    return 0;
    800045d0:	8aaa                	mv	s5,a0
    800045d2:	b5fd                	j	800044c0 <create+0x76>

00000000800045d4 <sys_dup>:
{
    800045d4:	7179                	addi	sp,sp,-48
    800045d6:	f406                	sd	ra,40(sp)
    800045d8:	f022                	sd	s0,32(sp)
    800045da:	ec26                	sd	s1,24(sp)
    800045dc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045de:	fd840613          	addi	a2,s0,-40
    800045e2:	4581                	li	a1,0
    800045e4:	4501                	li	a0,0
    800045e6:	00000097          	auipc	ra,0x0
    800045ea:	dc2080e7          	jalr	-574(ra) # 800043a8 <argfd>
    return -1;
    800045ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045f0:	02054363          	bltz	a0,80004616 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800045f4:	fd843503          	ld	a0,-40(s0)
    800045f8:	00000097          	auipc	ra,0x0
    800045fc:	e10080e7          	jalr	-496(ra) # 80004408 <fdalloc>
    80004600:	84aa                	mv	s1,a0
    return -1;
    80004602:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004604:	00054963          	bltz	a0,80004616 <sys_dup+0x42>
  filedup(f);
    80004608:	fd843503          	ld	a0,-40(s0)
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	310080e7          	jalr	784(ra) # 8000391c <filedup>
  return fd;
    80004614:	87a6                	mv	a5,s1
}
    80004616:	853e                	mv	a0,a5
    80004618:	70a2                	ld	ra,40(sp)
    8000461a:	7402                	ld	s0,32(sp)
    8000461c:	64e2                	ld	s1,24(sp)
    8000461e:	6145                	addi	sp,sp,48
    80004620:	8082                	ret

0000000080004622 <sys_read>:
{
    80004622:	7179                	addi	sp,sp,-48
    80004624:	f406                	sd	ra,40(sp)
    80004626:	f022                	sd	s0,32(sp)
    80004628:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000462a:	fd840593          	addi	a1,s0,-40
    8000462e:	4505                	li	a0,1
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	956080e7          	jalr	-1706(ra) # 80001f86 <argaddr>
  argint(2, &n);
    80004638:	fe440593          	addi	a1,s0,-28
    8000463c:	4509                	li	a0,2
    8000463e:	ffffe097          	auipc	ra,0xffffe
    80004642:	928080e7          	jalr	-1752(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    80004646:	fe840613          	addi	a2,s0,-24
    8000464a:	4581                	li	a1,0
    8000464c:	4501                	li	a0,0
    8000464e:	00000097          	auipc	ra,0x0
    80004652:	d5a080e7          	jalr	-678(ra) # 800043a8 <argfd>
    80004656:	87aa                	mv	a5,a0
    return -1;
    80004658:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000465a:	0007cc63          	bltz	a5,80004672 <sys_read+0x50>
  return fileread(f, p, n);
    8000465e:	fe442603          	lw	a2,-28(s0)
    80004662:	fd843583          	ld	a1,-40(s0)
    80004666:	fe843503          	ld	a0,-24(s0)
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	43e080e7          	jalr	1086(ra) # 80003aa8 <fileread>
}
    80004672:	70a2                	ld	ra,40(sp)
    80004674:	7402                	ld	s0,32(sp)
    80004676:	6145                	addi	sp,sp,48
    80004678:	8082                	ret

000000008000467a <sys_write>:
{
    8000467a:	7179                	addi	sp,sp,-48
    8000467c:	f406                	sd	ra,40(sp)
    8000467e:	f022                	sd	s0,32(sp)
    80004680:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004682:	fd840593          	addi	a1,s0,-40
    80004686:	4505                	li	a0,1
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	8fe080e7          	jalr	-1794(ra) # 80001f86 <argaddr>
  argint(2, &n);
    80004690:	fe440593          	addi	a1,s0,-28
    80004694:	4509                	li	a0,2
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	8d0080e7          	jalr	-1840(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    8000469e:	fe840613          	addi	a2,s0,-24
    800046a2:	4581                	li	a1,0
    800046a4:	4501                	li	a0,0
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	d02080e7          	jalr	-766(ra) # 800043a8 <argfd>
    800046ae:	87aa                	mv	a5,a0
    return -1;
    800046b0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046b2:	0007cc63          	bltz	a5,800046ca <sys_write+0x50>
  return filewrite(f, p, n);
    800046b6:	fe442603          	lw	a2,-28(s0)
    800046ba:	fd843583          	ld	a1,-40(s0)
    800046be:	fe843503          	ld	a0,-24(s0)
    800046c2:	fffff097          	auipc	ra,0xfffff
    800046c6:	4a8080e7          	jalr	1192(ra) # 80003b6a <filewrite>
}
    800046ca:	70a2                	ld	ra,40(sp)
    800046cc:	7402                	ld	s0,32(sp)
    800046ce:	6145                	addi	sp,sp,48
    800046d0:	8082                	ret

00000000800046d2 <sys_close>:
{
    800046d2:	1101                	addi	sp,sp,-32
    800046d4:	ec06                	sd	ra,24(sp)
    800046d6:	e822                	sd	s0,16(sp)
    800046d8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046da:	fe040613          	addi	a2,s0,-32
    800046de:	fec40593          	addi	a1,s0,-20
    800046e2:	4501                	li	a0,0
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	cc4080e7          	jalr	-828(ra) # 800043a8 <argfd>
    return -1;
    800046ec:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046ee:	02054463          	bltz	a0,80004716 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046f2:	ffffc097          	auipc	ra,0xffffc
    800046f6:	760080e7          	jalr	1888(ra) # 80000e52 <myproc>
    800046fa:	fec42783          	lw	a5,-20(s0)
    800046fe:	07e9                	addi	a5,a5,26
    80004700:	078e                	slli	a5,a5,0x3
    80004702:	97aa                	add	a5,a5,a0
    80004704:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004708:	fe043503          	ld	a0,-32(s0)
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	262080e7          	jalr	610(ra) # 8000396e <fileclose>
  return 0;
    80004714:	4781                	li	a5,0
}
    80004716:	853e                	mv	a0,a5
    80004718:	60e2                	ld	ra,24(sp)
    8000471a:	6442                	ld	s0,16(sp)
    8000471c:	6105                	addi	sp,sp,32
    8000471e:	8082                	ret

0000000080004720 <sys_fstat>:
{
    80004720:	1101                	addi	sp,sp,-32
    80004722:	ec06                	sd	ra,24(sp)
    80004724:	e822                	sd	s0,16(sp)
    80004726:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004728:	fe040593          	addi	a1,s0,-32
    8000472c:	4505                	li	a0,1
    8000472e:	ffffe097          	auipc	ra,0xffffe
    80004732:	858080e7          	jalr	-1960(ra) # 80001f86 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004736:	fe840613          	addi	a2,s0,-24
    8000473a:	4581                	li	a1,0
    8000473c:	4501                	li	a0,0
    8000473e:	00000097          	auipc	ra,0x0
    80004742:	c6a080e7          	jalr	-918(ra) # 800043a8 <argfd>
    80004746:	87aa                	mv	a5,a0
    return -1;
    80004748:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000474a:	0007ca63          	bltz	a5,8000475e <sys_fstat+0x3e>
  return filestat(f, st);
    8000474e:	fe043583          	ld	a1,-32(s0)
    80004752:	fe843503          	ld	a0,-24(s0)
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	2e0080e7          	jalr	736(ra) # 80003a36 <filestat>
}
    8000475e:	60e2                	ld	ra,24(sp)
    80004760:	6442                	ld	s0,16(sp)
    80004762:	6105                	addi	sp,sp,32
    80004764:	8082                	ret

0000000080004766 <sys_link>:
{
    80004766:	7169                	addi	sp,sp,-304
    80004768:	f606                	sd	ra,296(sp)
    8000476a:	f222                	sd	s0,288(sp)
    8000476c:	ee26                	sd	s1,280(sp)
    8000476e:	ea4a                	sd	s2,272(sp)
    80004770:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004772:	08000613          	li	a2,128
    80004776:	ed040593          	addi	a1,s0,-304
    8000477a:	4501                	li	a0,0
    8000477c:	ffffe097          	auipc	ra,0xffffe
    80004780:	82a080e7          	jalr	-2006(ra) # 80001fa6 <argstr>
    return -1;
    80004784:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004786:	10054e63          	bltz	a0,800048a2 <sys_link+0x13c>
    8000478a:	08000613          	li	a2,128
    8000478e:	f5040593          	addi	a1,s0,-176
    80004792:	4505                	li	a0,1
    80004794:	ffffe097          	auipc	ra,0xffffe
    80004798:	812080e7          	jalr	-2030(ra) # 80001fa6 <argstr>
    return -1;
    8000479c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000479e:	10054263          	bltz	a0,800048a2 <sys_link+0x13c>
  begin_op();
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	d00080e7          	jalr	-768(ra) # 800034a2 <begin_op>
  if((ip = namei(old)) == 0){
    800047aa:	ed040513          	addi	a0,s0,-304
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	ad8080e7          	jalr	-1320(ra) # 80003286 <namei>
    800047b6:	84aa                	mv	s1,a0
    800047b8:	c551                	beqz	a0,80004844 <sys_link+0xde>
  ilock(ip);
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	326080e7          	jalr	806(ra) # 80002ae0 <ilock>
  if(ip->type == T_DIR){
    800047c2:	04449703          	lh	a4,68(s1)
    800047c6:	4785                	li	a5,1
    800047c8:	08f70463          	beq	a4,a5,80004850 <sys_link+0xea>
  ip->nlink++;
    800047cc:	04a4d783          	lhu	a5,74(s1)
    800047d0:	2785                	addiw	a5,a5,1
    800047d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047d6:	8526                	mv	a0,s1
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	23e080e7          	jalr	574(ra) # 80002a16 <iupdate>
  iunlock(ip);
    800047e0:	8526                	mv	a0,s1
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	3c0080e7          	jalr	960(ra) # 80002ba2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047ea:	fd040593          	addi	a1,s0,-48
    800047ee:	f5040513          	addi	a0,s0,-176
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	ab2080e7          	jalr	-1358(ra) # 800032a4 <nameiparent>
    800047fa:	892a                	mv	s2,a0
    800047fc:	c935                	beqz	a0,80004870 <sys_link+0x10a>
  ilock(dp);
    800047fe:	ffffe097          	auipc	ra,0xffffe
    80004802:	2e2080e7          	jalr	738(ra) # 80002ae0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004806:	00092703          	lw	a4,0(s2)
    8000480a:	409c                	lw	a5,0(s1)
    8000480c:	04f71d63          	bne	a4,a5,80004866 <sys_link+0x100>
    80004810:	40d0                	lw	a2,4(s1)
    80004812:	fd040593          	addi	a1,s0,-48
    80004816:	854a                	mv	a0,s2
    80004818:	fffff097          	auipc	ra,0xfffff
    8000481c:	9bc080e7          	jalr	-1604(ra) # 800031d4 <dirlink>
    80004820:	04054363          	bltz	a0,80004866 <sys_link+0x100>
  iunlockput(dp);
    80004824:	854a                	mv	a0,s2
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	51c080e7          	jalr	1308(ra) # 80002d42 <iunlockput>
  iput(ip);
    8000482e:	8526                	mv	a0,s1
    80004830:	ffffe097          	auipc	ra,0xffffe
    80004834:	46a080e7          	jalr	1130(ra) # 80002c9a <iput>
  end_op();
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	cea080e7          	jalr	-790(ra) # 80003522 <end_op>
  return 0;
    80004840:	4781                	li	a5,0
    80004842:	a085                	j	800048a2 <sys_link+0x13c>
    end_op();
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	cde080e7          	jalr	-802(ra) # 80003522 <end_op>
    return -1;
    8000484c:	57fd                	li	a5,-1
    8000484e:	a891                	j	800048a2 <sys_link+0x13c>
    iunlockput(ip);
    80004850:	8526                	mv	a0,s1
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	4f0080e7          	jalr	1264(ra) # 80002d42 <iunlockput>
    end_op();
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	cc8080e7          	jalr	-824(ra) # 80003522 <end_op>
    return -1;
    80004862:	57fd                	li	a5,-1
    80004864:	a83d                	j	800048a2 <sys_link+0x13c>
    iunlockput(dp);
    80004866:	854a                	mv	a0,s2
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	4da080e7          	jalr	1242(ra) # 80002d42 <iunlockput>
  ilock(ip);
    80004870:	8526                	mv	a0,s1
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	26e080e7          	jalr	622(ra) # 80002ae0 <ilock>
  ip->nlink--;
    8000487a:	04a4d783          	lhu	a5,74(s1)
    8000487e:	37fd                	addiw	a5,a5,-1
    80004880:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004884:	8526                	mv	a0,s1
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	190080e7          	jalr	400(ra) # 80002a16 <iupdate>
  iunlockput(ip);
    8000488e:	8526                	mv	a0,s1
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	4b2080e7          	jalr	1202(ra) # 80002d42 <iunlockput>
  end_op();
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	c8a080e7          	jalr	-886(ra) # 80003522 <end_op>
  return -1;
    800048a0:	57fd                	li	a5,-1
}
    800048a2:	853e                	mv	a0,a5
    800048a4:	70b2                	ld	ra,296(sp)
    800048a6:	7412                	ld	s0,288(sp)
    800048a8:	64f2                	ld	s1,280(sp)
    800048aa:	6952                	ld	s2,272(sp)
    800048ac:	6155                	addi	sp,sp,304
    800048ae:	8082                	ret

00000000800048b0 <sys_unlink>:
{
    800048b0:	7151                	addi	sp,sp,-240
    800048b2:	f586                	sd	ra,232(sp)
    800048b4:	f1a2                	sd	s0,224(sp)
    800048b6:	eda6                	sd	s1,216(sp)
    800048b8:	e9ca                	sd	s2,208(sp)
    800048ba:	e5ce                	sd	s3,200(sp)
    800048bc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048be:	08000613          	li	a2,128
    800048c2:	f3040593          	addi	a1,s0,-208
    800048c6:	4501                	li	a0,0
    800048c8:	ffffd097          	auipc	ra,0xffffd
    800048cc:	6de080e7          	jalr	1758(ra) # 80001fa6 <argstr>
    800048d0:	18054163          	bltz	a0,80004a52 <sys_unlink+0x1a2>
  begin_op();
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	bce080e7          	jalr	-1074(ra) # 800034a2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048dc:	fb040593          	addi	a1,s0,-80
    800048e0:	f3040513          	addi	a0,s0,-208
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	9c0080e7          	jalr	-1600(ra) # 800032a4 <nameiparent>
    800048ec:	84aa                	mv	s1,a0
    800048ee:	c979                	beqz	a0,800049c4 <sys_unlink+0x114>
  ilock(dp);
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	1f0080e7          	jalr	496(ra) # 80002ae0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048f8:	00004597          	auipc	a1,0x4
    800048fc:	d7858593          	addi	a1,a1,-648 # 80008670 <syscalls+0x2a0>
    80004900:	fb040513          	addi	a0,s0,-80
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	6a6080e7          	jalr	1702(ra) # 80002faa <namecmp>
    8000490c:	14050a63          	beqz	a0,80004a60 <sys_unlink+0x1b0>
    80004910:	00004597          	auipc	a1,0x4
    80004914:	d6858593          	addi	a1,a1,-664 # 80008678 <syscalls+0x2a8>
    80004918:	fb040513          	addi	a0,s0,-80
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	68e080e7          	jalr	1678(ra) # 80002faa <namecmp>
    80004924:	12050e63          	beqz	a0,80004a60 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004928:	f2c40613          	addi	a2,s0,-212
    8000492c:	fb040593          	addi	a1,s0,-80
    80004930:	8526                	mv	a0,s1
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	692080e7          	jalr	1682(ra) # 80002fc4 <dirlookup>
    8000493a:	892a                	mv	s2,a0
    8000493c:	12050263          	beqz	a0,80004a60 <sys_unlink+0x1b0>
  ilock(ip);
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	1a0080e7          	jalr	416(ra) # 80002ae0 <ilock>
  if(ip->nlink < 1)
    80004948:	04a91783          	lh	a5,74(s2)
    8000494c:	08f05263          	blez	a5,800049d0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004950:	04491703          	lh	a4,68(s2)
    80004954:	4785                	li	a5,1
    80004956:	08f70563          	beq	a4,a5,800049e0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000495a:	4641                	li	a2,16
    8000495c:	4581                	li	a1,0
    8000495e:	fc040513          	addi	a0,s0,-64
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	816080e7          	jalr	-2026(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000496a:	4741                	li	a4,16
    8000496c:	f2c42683          	lw	a3,-212(s0)
    80004970:	fc040613          	addi	a2,s0,-64
    80004974:	4581                	li	a1,0
    80004976:	8526                	mv	a0,s1
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	514080e7          	jalr	1300(ra) # 80002e8c <writei>
    80004980:	47c1                	li	a5,16
    80004982:	0af51563          	bne	a0,a5,80004a2c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004986:	04491703          	lh	a4,68(s2)
    8000498a:	4785                	li	a5,1
    8000498c:	0af70863          	beq	a4,a5,80004a3c <sys_unlink+0x18c>
  iunlockput(dp);
    80004990:	8526                	mv	a0,s1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	3b0080e7          	jalr	944(ra) # 80002d42 <iunlockput>
  ip->nlink--;
    8000499a:	04a95783          	lhu	a5,74(s2)
    8000499e:	37fd                	addiw	a5,a5,-1
    800049a0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049a4:	854a                	mv	a0,s2
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	070080e7          	jalr	112(ra) # 80002a16 <iupdate>
  iunlockput(ip);
    800049ae:	854a                	mv	a0,s2
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	392080e7          	jalr	914(ra) # 80002d42 <iunlockput>
  end_op();
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	b6a080e7          	jalr	-1174(ra) # 80003522 <end_op>
  return 0;
    800049c0:	4501                	li	a0,0
    800049c2:	a84d                	j	80004a74 <sys_unlink+0x1c4>
    end_op();
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	b5e080e7          	jalr	-1186(ra) # 80003522 <end_op>
    return -1;
    800049cc:	557d                	li	a0,-1
    800049ce:	a05d                	j	80004a74 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049d0:	00004517          	auipc	a0,0x4
    800049d4:	cb050513          	addi	a0,a0,-848 # 80008680 <syscalls+0x2b0>
    800049d8:	00001097          	auipc	ra,0x1
    800049dc:	1b6080e7          	jalr	438(ra) # 80005b8e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049e0:	04c92703          	lw	a4,76(s2)
    800049e4:	02000793          	li	a5,32
    800049e8:	f6e7f9e3          	bgeu	a5,a4,8000495a <sys_unlink+0xaa>
    800049ec:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f0:	4741                	li	a4,16
    800049f2:	86ce                	mv	a3,s3
    800049f4:	f1840613          	addi	a2,s0,-232
    800049f8:	4581                	li	a1,0
    800049fa:	854a                	mv	a0,s2
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	398080e7          	jalr	920(ra) # 80002d94 <readi>
    80004a04:	47c1                	li	a5,16
    80004a06:	00f51b63          	bne	a0,a5,80004a1c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a0a:	f1845783          	lhu	a5,-232(s0)
    80004a0e:	e7a1                	bnez	a5,80004a56 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a10:	29c1                	addiw	s3,s3,16
    80004a12:	04c92783          	lw	a5,76(s2)
    80004a16:	fcf9ede3          	bltu	s3,a5,800049f0 <sys_unlink+0x140>
    80004a1a:	b781                	j	8000495a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a1c:	00004517          	auipc	a0,0x4
    80004a20:	c7c50513          	addi	a0,a0,-900 # 80008698 <syscalls+0x2c8>
    80004a24:	00001097          	auipc	ra,0x1
    80004a28:	16a080e7          	jalr	362(ra) # 80005b8e <panic>
    panic("unlink: writei");
    80004a2c:	00004517          	auipc	a0,0x4
    80004a30:	c8450513          	addi	a0,a0,-892 # 800086b0 <syscalls+0x2e0>
    80004a34:	00001097          	auipc	ra,0x1
    80004a38:	15a080e7          	jalr	346(ra) # 80005b8e <panic>
    dp->nlink--;
    80004a3c:	04a4d783          	lhu	a5,74(s1)
    80004a40:	37fd                	addiw	a5,a5,-1
    80004a42:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a46:	8526                	mv	a0,s1
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	fce080e7          	jalr	-50(ra) # 80002a16 <iupdate>
    80004a50:	b781                	j	80004990 <sys_unlink+0xe0>
    return -1;
    80004a52:	557d                	li	a0,-1
    80004a54:	a005                	j	80004a74 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a56:	854a                	mv	a0,s2
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	2ea080e7          	jalr	746(ra) # 80002d42 <iunlockput>
  iunlockput(dp);
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	2e0080e7          	jalr	736(ra) # 80002d42 <iunlockput>
  end_op();
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	ab8080e7          	jalr	-1352(ra) # 80003522 <end_op>
  return -1;
    80004a72:	557d                	li	a0,-1
}
    80004a74:	70ae                	ld	ra,232(sp)
    80004a76:	740e                	ld	s0,224(sp)
    80004a78:	64ee                	ld	s1,216(sp)
    80004a7a:	694e                	ld	s2,208(sp)
    80004a7c:	69ae                	ld	s3,200(sp)
    80004a7e:	616d                	addi	sp,sp,240
    80004a80:	8082                	ret

0000000080004a82 <sys_open>:

uint64
sys_open(void)
{
    80004a82:	7131                	addi	sp,sp,-192
    80004a84:	fd06                	sd	ra,184(sp)
    80004a86:	f922                	sd	s0,176(sp)
    80004a88:	f526                	sd	s1,168(sp)
    80004a8a:	f14a                	sd	s2,160(sp)
    80004a8c:	ed4e                	sd	s3,152(sp)
    80004a8e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a90:	f4c40593          	addi	a1,s0,-180
    80004a94:	4505                	li	a0,1
    80004a96:	ffffd097          	auipc	ra,0xffffd
    80004a9a:	4d0080e7          	jalr	1232(ra) # 80001f66 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a9e:	08000613          	li	a2,128
    80004aa2:	f5040593          	addi	a1,s0,-176
    80004aa6:	4501                	li	a0,0
    80004aa8:	ffffd097          	auipc	ra,0xffffd
    80004aac:	4fe080e7          	jalr	1278(ra) # 80001fa6 <argstr>
    80004ab0:	87aa                	mv	a5,a0
    return -1;
    80004ab2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ab4:	0a07c963          	bltz	a5,80004b66 <sys_open+0xe4>

  begin_op();
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	9ea080e7          	jalr	-1558(ra) # 800034a2 <begin_op>

  if(omode & O_CREATE){
    80004ac0:	f4c42783          	lw	a5,-180(s0)
    80004ac4:	2007f793          	andi	a5,a5,512
    80004ac8:	cfc5                	beqz	a5,80004b80 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004aca:	4681                	li	a3,0
    80004acc:	4601                	li	a2,0
    80004ace:	4589                	li	a1,2
    80004ad0:	f5040513          	addi	a0,s0,-176
    80004ad4:	00000097          	auipc	ra,0x0
    80004ad8:	976080e7          	jalr	-1674(ra) # 8000444a <create>
    80004adc:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ade:	c959                	beqz	a0,80004b74 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ae0:	04449703          	lh	a4,68(s1)
    80004ae4:	478d                	li	a5,3
    80004ae6:	00f71763          	bne	a4,a5,80004af4 <sys_open+0x72>
    80004aea:	0464d703          	lhu	a4,70(s1)
    80004aee:	47a5                	li	a5,9
    80004af0:	0ce7ed63          	bltu	a5,a4,80004bca <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	dbe080e7          	jalr	-578(ra) # 800038b2 <filealloc>
    80004afc:	89aa                	mv	s3,a0
    80004afe:	10050363          	beqz	a0,80004c04 <sys_open+0x182>
    80004b02:	00000097          	auipc	ra,0x0
    80004b06:	906080e7          	jalr	-1786(ra) # 80004408 <fdalloc>
    80004b0a:	892a                	mv	s2,a0
    80004b0c:	0e054763          	bltz	a0,80004bfa <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b10:	04449703          	lh	a4,68(s1)
    80004b14:	478d                	li	a5,3
    80004b16:	0cf70563          	beq	a4,a5,80004be0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b1a:	4789                	li	a5,2
    80004b1c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b20:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b24:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b28:	f4c42783          	lw	a5,-180(s0)
    80004b2c:	0017c713          	xori	a4,a5,1
    80004b30:	8b05                	andi	a4,a4,1
    80004b32:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b36:	0037f713          	andi	a4,a5,3
    80004b3a:	00e03733          	snez	a4,a4
    80004b3e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b42:	4007f793          	andi	a5,a5,1024
    80004b46:	c791                	beqz	a5,80004b52 <sys_open+0xd0>
    80004b48:	04449703          	lh	a4,68(s1)
    80004b4c:	4789                	li	a5,2
    80004b4e:	0af70063          	beq	a4,a5,80004bee <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	04e080e7          	jalr	78(ra) # 80002ba2 <iunlock>
  end_op();
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	9c6080e7          	jalr	-1594(ra) # 80003522 <end_op>

  return fd;
    80004b64:	854a                	mv	a0,s2
}
    80004b66:	70ea                	ld	ra,184(sp)
    80004b68:	744a                	ld	s0,176(sp)
    80004b6a:	74aa                	ld	s1,168(sp)
    80004b6c:	790a                	ld	s2,160(sp)
    80004b6e:	69ea                	ld	s3,152(sp)
    80004b70:	6129                	addi	sp,sp,192
    80004b72:	8082                	ret
      end_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	9ae080e7          	jalr	-1618(ra) # 80003522 <end_op>
      return -1;
    80004b7c:	557d                	li	a0,-1
    80004b7e:	b7e5                	j	80004b66 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b80:	f5040513          	addi	a0,s0,-176
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	702080e7          	jalr	1794(ra) # 80003286 <namei>
    80004b8c:	84aa                	mv	s1,a0
    80004b8e:	c905                	beqz	a0,80004bbe <sys_open+0x13c>
    ilock(ip);
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	f50080e7          	jalr	-176(ra) # 80002ae0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b98:	04449703          	lh	a4,68(s1)
    80004b9c:	4785                	li	a5,1
    80004b9e:	f4f711e3          	bne	a4,a5,80004ae0 <sys_open+0x5e>
    80004ba2:	f4c42783          	lw	a5,-180(s0)
    80004ba6:	d7b9                	beqz	a5,80004af4 <sys_open+0x72>
      iunlockput(ip);
    80004ba8:	8526                	mv	a0,s1
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	198080e7          	jalr	408(ra) # 80002d42 <iunlockput>
      end_op();
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	970080e7          	jalr	-1680(ra) # 80003522 <end_op>
      return -1;
    80004bba:	557d                	li	a0,-1
    80004bbc:	b76d                	j	80004b66 <sys_open+0xe4>
      end_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	964080e7          	jalr	-1692(ra) # 80003522 <end_op>
      return -1;
    80004bc6:	557d                	li	a0,-1
    80004bc8:	bf79                	j	80004b66 <sys_open+0xe4>
    iunlockput(ip);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	176080e7          	jalr	374(ra) # 80002d42 <iunlockput>
    end_op();
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	94e080e7          	jalr	-1714(ra) # 80003522 <end_op>
    return -1;
    80004bdc:	557d                	li	a0,-1
    80004bde:	b761                	j	80004b66 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004be0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004be4:	04649783          	lh	a5,70(s1)
    80004be8:	02f99223          	sh	a5,36(s3)
    80004bec:	bf25                	j	80004b24 <sys_open+0xa2>
    itrunc(ip);
    80004bee:	8526                	mv	a0,s1
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	ffe080e7          	jalr	-2(ra) # 80002bee <itrunc>
    80004bf8:	bfa9                	j	80004b52 <sys_open+0xd0>
      fileclose(f);
    80004bfa:	854e                	mv	a0,s3
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	d72080e7          	jalr	-654(ra) # 8000396e <fileclose>
    iunlockput(ip);
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	13c080e7          	jalr	316(ra) # 80002d42 <iunlockput>
    end_op();
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	914080e7          	jalr	-1772(ra) # 80003522 <end_op>
    return -1;
    80004c16:	557d                	li	a0,-1
    80004c18:	b7b9                	j	80004b66 <sys_open+0xe4>

0000000080004c1a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c1a:	7175                	addi	sp,sp,-144
    80004c1c:	e506                	sd	ra,136(sp)
    80004c1e:	e122                	sd	s0,128(sp)
    80004c20:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c22:	fffff097          	auipc	ra,0xfffff
    80004c26:	880080e7          	jalr	-1920(ra) # 800034a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c2a:	08000613          	li	a2,128
    80004c2e:	f7040593          	addi	a1,s0,-144
    80004c32:	4501                	li	a0,0
    80004c34:	ffffd097          	auipc	ra,0xffffd
    80004c38:	372080e7          	jalr	882(ra) # 80001fa6 <argstr>
    80004c3c:	02054963          	bltz	a0,80004c6e <sys_mkdir+0x54>
    80004c40:	4681                	li	a3,0
    80004c42:	4601                	li	a2,0
    80004c44:	4585                	li	a1,1
    80004c46:	f7040513          	addi	a0,s0,-144
    80004c4a:	00000097          	auipc	ra,0x0
    80004c4e:	800080e7          	jalr	-2048(ra) # 8000444a <create>
    80004c52:	cd11                	beqz	a0,80004c6e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	0ee080e7          	jalr	238(ra) # 80002d42 <iunlockput>
  end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	8c6080e7          	jalr	-1850(ra) # 80003522 <end_op>
  return 0;
    80004c64:	4501                	li	a0,0
}
    80004c66:	60aa                	ld	ra,136(sp)
    80004c68:	640a                	ld	s0,128(sp)
    80004c6a:	6149                	addi	sp,sp,144
    80004c6c:	8082                	ret
    end_op();
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	8b4080e7          	jalr	-1868(ra) # 80003522 <end_op>
    return -1;
    80004c76:	557d                	li	a0,-1
    80004c78:	b7fd                	j	80004c66 <sys_mkdir+0x4c>

0000000080004c7a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c7a:	7135                	addi	sp,sp,-160
    80004c7c:	ed06                	sd	ra,152(sp)
    80004c7e:	e922                	sd	s0,144(sp)
    80004c80:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	820080e7          	jalr	-2016(ra) # 800034a2 <begin_op>
  argint(1, &major);
    80004c8a:	f6c40593          	addi	a1,s0,-148
    80004c8e:	4505                	li	a0,1
    80004c90:	ffffd097          	auipc	ra,0xffffd
    80004c94:	2d6080e7          	jalr	726(ra) # 80001f66 <argint>
  argint(2, &minor);
    80004c98:	f6840593          	addi	a1,s0,-152
    80004c9c:	4509                	li	a0,2
    80004c9e:	ffffd097          	auipc	ra,0xffffd
    80004ca2:	2c8080e7          	jalr	712(ra) # 80001f66 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ca6:	08000613          	li	a2,128
    80004caa:	f7040593          	addi	a1,s0,-144
    80004cae:	4501                	li	a0,0
    80004cb0:	ffffd097          	auipc	ra,0xffffd
    80004cb4:	2f6080e7          	jalr	758(ra) # 80001fa6 <argstr>
    80004cb8:	02054b63          	bltz	a0,80004cee <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cbc:	f6841683          	lh	a3,-152(s0)
    80004cc0:	f6c41603          	lh	a2,-148(s0)
    80004cc4:	458d                	li	a1,3
    80004cc6:	f7040513          	addi	a0,s0,-144
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	780080e7          	jalr	1920(ra) # 8000444a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cd2:	cd11                	beqz	a0,80004cee <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	06e080e7          	jalr	110(ra) # 80002d42 <iunlockput>
  end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	846080e7          	jalr	-1978(ra) # 80003522 <end_op>
  return 0;
    80004ce4:	4501                	li	a0,0
}
    80004ce6:	60ea                	ld	ra,152(sp)
    80004ce8:	644a                	ld	s0,144(sp)
    80004cea:	610d                	addi	sp,sp,160
    80004cec:	8082                	ret
    end_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	834080e7          	jalr	-1996(ra) # 80003522 <end_op>
    return -1;
    80004cf6:	557d                	li	a0,-1
    80004cf8:	b7fd                	j	80004ce6 <sys_mknod+0x6c>

0000000080004cfa <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cfa:	7135                	addi	sp,sp,-160
    80004cfc:	ed06                	sd	ra,152(sp)
    80004cfe:	e922                	sd	s0,144(sp)
    80004d00:	e526                	sd	s1,136(sp)
    80004d02:	e14a                	sd	s2,128(sp)
    80004d04:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d06:	ffffc097          	auipc	ra,0xffffc
    80004d0a:	14c080e7          	jalr	332(ra) # 80000e52 <myproc>
    80004d0e:	892a                	mv	s2,a0
  
  begin_op();
    80004d10:	ffffe097          	auipc	ra,0xffffe
    80004d14:	792080e7          	jalr	1938(ra) # 800034a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d18:	08000613          	li	a2,128
    80004d1c:	f6040593          	addi	a1,s0,-160
    80004d20:	4501                	li	a0,0
    80004d22:	ffffd097          	auipc	ra,0xffffd
    80004d26:	284080e7          	jalr	644(ra) # 80001fa6 <argstr>
    80004d2a:	04054b63          	bltz	a0,80004d80 <sys_chdir+0x86>
    80004d2e:	f6040513          	addi	a0,s0,-160
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	554080e7          	jalr	1364(ra) # 80003286 <namei>
    80004d3a:	84aa                	mv	s1,a0
    80004d3c:	c131                	beqz	a0,80004d80 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	da2080e7          	jalr	-606(ra) # 80002ae0 <ilock>
  if(ip->type != T_DIR){
    80004d46:	04449703          	lh	a4,68(s1)
    80004d4a:	4785                	li	a5,1
    80004d4c:	04f71063          	bne	a4,a5,80004d8c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d50:	8526                	mv	a0,s1
    80004d52:	ffffe097          	auipc	ra,0xffffe
    80004d56:	e50080e7          	jalr	-432(ra) # 80002ba2 <iunlock>
  iput(p->cwd);
    80004d5a:	15093503          	ld	a0,336(s2)
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	f3c080e7          	jalr	-196(ra) # 80002c9a <iput>
  end_op();
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	7bc080e7          	jalr	1980(ra) # 80003522 <end_op>
  p->cwd = ip;
    80004d6e:	14993823          	sd	s1,336(s2)
  return 0;
    80004d72:	4501                	li	a0,0
}
    80004d74:	60ea                	ld	ra,152(sp)
    80004d76:	644a                	ld	s0,144(sp)
    80004d78:	64aa                	ld	s1,136(sp)
    80004d7a:	690a                	ld	s2,128(sp)
    80004d7c:	610d                	addi	sp,sp,160
    80004d7e:	8082                	ret
    end_op();
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	7a2080e7          	jalr	1954(ra) # 80003522 <end_op>
    return -1;
    80004d88:	557d                	li	a0,-1
    80004d8a:	b7ed                	j	80004d74 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	fb4080e7          	jalr	-76(ra) # 80002d42 <iunlockput>
    end_op();
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	78c080e7          	jalr	1932(ra) # 80003522 <end_op>
    return -1;
    80004d9e:	557d                	li	a0,-1
    80004da0:	bfd1                	j	80004d74 <sys_chdir+0x7a>

0000000080004da2 <sys_exec>:

uint64
sys_exec(void)
{
    80004da2:	7145                	addi	sp,sp,-464
    80004da4:	e786                	sd	ra,456(sp)
    80004da6:	e3a2                	sd	s0,448(sp)
    80004da8:	ff26                	sd	s1,440(sp)
    80004daa:	fb4a                	sd	s2,432(sp)
    80004dac:	f74e                	sd	s3,424(sp)
    80004dae:	f352                	sd	s4,416(sp)
    80004db0:	ef56                	sd	s5,408(sp)
    80004db2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004db4:	e3840593          	addi	a1,s0,-456
    80004db8:	4505                	li	a0,1
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	1cc080e7          	jalr	460(ra) # 80001f86 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004dc2:	08000613          	li	a2,128
    80004dc6:	f4040593          	addi	a1,s0,-192
    80004dca:	4501                	li	a0,0
    80004dcc:	ffffd097          	auipc	ra,0xffffd
    80004dd0:	1da080e7          	jalr	474(ra) # 80001fa6 <argstr>
    80004dd4:	87aa                	mv	a5,a0
    return -1;
    80004dd6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004dd8:	0c07c263          	bltz	a5,80004e9c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ddc:	10000613          	li	a2,256
    80004de0:	4581                	li	a1,0
    80004de2:	e4040513          	addi	a0,s0,-448
    80004de6:	ffffb097          	auipc	ra,0xffffb
    80004dea:	392080e7          	jalr	914(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004dee:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004df2:	89a6                	mv	s3,s1
    80004df4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004df6:	02000a13          	li	s4,32
    80004dfa:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004dfe:	00391793          	slli	a5,s2,0x3
    80004e02:	e3040593          	addi	a1,s0,-464
    80004e06:	e3843503          	ld	a0,-456(s0)
    80004e0a:	953e                	add	a0,a0,a5
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	0bc080e7          	jalr	188(ra) # 80001ec8 <fetchaddr>
    80004e14:	02054a63          	bltz	a0,80004e48 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e18:	e3043783          	ld	a5,-464(s0)
    80004e1c:	c3b9                	beqz	a5,80004e62 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e1e:	ffffb097          	auipc	ra,0xffffb
    80004e22:	2fa080e7          	jalr	762(ra) # 80000118 <kalloc>
    80004e26:	85aa                	mv	a1,a0
    80004e28:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e2c:	cd11                	beqz	a0,80004e48 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e2e:	6605                	lui	a2,0x1
    80004e30:	e3043503          	ld	a0,-464(s0)
    80004e34:	ffffd097          	auipc	ra,0xffffd
    80004e38:	0e6080e7          	jalr	230(ra) # 80001f1a <fetchstr>
    80004e3c:	00054663          	bltz	a0,80004e48 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e40:	0905                	addi	s2,s2,1
    80004e42:	09a1                	addi	s3,s3,8
    80004e44:	fb491be3          	bne	s2,s4,80004dfa <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e48:	10048913          	addi	s2,s1,256
    80004e4c:	6088                	ld	a0,0(s1)
    80004e4e:	c531                	beqz	a0,80004e9a <sys_exec+0xf8>
    kfree(argv[i]);
    80004e50:	ffffb097          	auipc	ra,0xffffb
    80004e54:	1cc080e7          	jalr	460(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e58:	04a1                	addi	s1,s1,8
    80004e5a:	ff2499e3          	bne	s1,s2,80004e4c <sys_exec+0xaa>
  return -1;
    80004e5e:	557d                	li	a0,-1
    80004e60:	a835                	j	80004e9c <sys_exec+0xfa>
      argv[i] = 0;
    80004e62:	0a8e                	slli	s5,s5,0x3
    80004e64:	fc040793          	addi	a5,s0,-64
    80004e68:	9abe                	add	s5,s5,a5
    80004e6a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e6e:	e4040593          	addi	a1,s0,-448
    80004e72:	f4040513          	addi	a0,s0,-192
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	172080e7          	jalr	370(ra) # 80003fe8 <exec>
    80004e7e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e80:	10048993          	addi	s3,s1,256
    80004e84:	6088                	ld	a0,0(s1)
    80004e86:	c901                	beqz	a0,80004e96 <sys_exec+0xf4>
    kfree(argv[i]);
    80004e88:	ffffb097          	auipc	ra,0xffffb
    80004e8c:	194080e7          	jalr	404(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e90:	04a1                	addi	s1,s1,8
    80004e92:	ff3499e3          	bne	s1,s3,80004e84 <sys_exec+0xe2>
  return ret;
    80004e96:	854a                	mv	a0,s2
    80004e98:	a011                	j	80004e9c <sys_exec+0xfa>
  return -1;
    80004e9a:	557d                	li	a0,-1
}
    80004e9c:	60be                	ld	ra,456(sp)
    80004e9e:	641e                	ld	s0,448(sp)
    80004ea0:	74fa                	ld	s1,440(sp)
    80004ea2:	795a                	ld	s2,432(sp)
    80004ea4:	79ba                	ld	s3,424(sp)
    80004ea6:	7a1a                	ld	s4,416(sp)
    80004ea8:	6afa                	ld	s5,408(sp)
    80004eaa:	6179                	addi	sp,sp,464
    80004eac:	8082                	ret

0000000080004eae <sys_pipe>:

uint64
sys_pipe(void)
{
    80004eae:	7139                	addi	sp,sp,-64
    80004eb0:	fc06                	sd	ra,56(sp)
    80004eb2:	f822                	sd	s0,48(sp)
    80004eb4:	f426                	sd	s1,40(sp)
    80004eb6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004eb8:	ffffc097          	auipc	ra,0xffffc
    80004ebc:	f9a080e7          	jalr	-102(ra) # 80000e52 <myproc>
    80004ec0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004ec2:	fd840593          	addi	a1,s0,-40
    80004ec6:	4501                	li	a0,0
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	0be080e7          	jalr	190(ra) # 80001f86 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004ed0:	fc840593          	addi	a1,s0,-56
    80004ed4:	fd040513          	addi	a0,s0,-48
    80004ed8:	fffff097          	auipc	ra,0xfffff
    80004edc:	dc6080e7          	jalr	-570(ra) # 80003c9e <pipealloc>
    return -1;
    80004ee0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ee2:	0c054463          	bltz	a0,80004faa <sys_pipe+0xfc>
  fd0 = -1;
    80004ee6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004eea:	fd043503          	ld	a0,-48(s0)
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	51a080e7          	jalr	1306(ra) # 80004408 <fdalloc>
    80004ef6:	fca42223          	sw	a0,-60(s0)
    80004efa:	08054b63          	bltz	a0,80004f90 <sys_pipe+0xe2>
    80004efe:	fc843503          	ld	a0,-56(s0)
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	506080e7          	jalr	1286(ra) # 80004408 <fdalloc>
    80004f0a:	fca42023          	sw	a0,-64(s0)
    80004f0e:	06054863          	bltz	a0,80004f7e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f12:	4691                	li	a3,4
    80004f14:	fc440613          	addi	a2,s0,-60
    80004f18:	fd843583          	ld	a1,-40(s0)
    80004f1c:	68a8                	ld	a0,80(s1)
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	bf0080e7          	jalr	-1040(ra) # 80000b0e <copyout>
    80004f26:	02054063          	bltz	a0,80004f46 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f2a:	4691                	li	a3,4
    80004f2c:	fc040613          	addi	a2,s0,-64
    80004f30:	fd843583          	ld	a1,-40(s0)
    80004f34:	0591                	addi	a1,a1,4
    80004f36:	68a8                	ld	a0,80(s1)
    80004f38:	ffffc097          	auipc	ra,0xffffc
    80004f3c:	bd6080e7          	jalr	-1066(ra) # 80000b0e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f40:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f42:	06055463          	bgez	a0,80004faa <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f46:	fc442783          	lw	a5,-60(s0)
    80004f4a:	07e9                	addi	a5,a5,26
    80004f4c:	078e                	slli	a5,a5,0x3
    80004f4e:	97a6                	add	a5,a5,s1
    80004f50:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f54:	fc042503          	lw	a0,-64(s0)
    80004f58:	0569                	addi	a0,a0,26
    80004f5a:	050e                	slli	a0,a0,0x3
    80004f5c:	94aa                	add	s1,s1,a0
    80004f5e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f62:	fd043503          	ld	a0,-48(s0)
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	a08080e7          	jalr	-1528(ra) # 8000396e <fileclose>
    fileclose(wf);
    80004f6e:	fc843503          	ld	a0,-56(s0)
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	9fc080e7          	jalr	-1540(ra) # 8000396e <fileclose>
    return -1;
    80004f7a:	57fd                	li	a5,-1
    80004f7c:	a03d                	j	80004faa <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f7e:	fc442783          	lw	a5,-60(s0)
    80004f82:	0007c763          	bltz	a5,80004f90 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f86:	07e9                	addi	a5,a5,26
    80004f88:	078e                	slli	a5,a5,0x3
    80004f8a:	94be                	add	s1,s1,a5
    80004f8c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f90:	fd043503          	ld	a0,-48(s0)
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	9da080e7          	jalr	-1574(ra) # 8000396e <fileclose>
    fileclose(wf);
    80004f9c:	fc843503          	ld	a0,-56(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	9ce080e7          	jalr	-1586(ra) # 8000396e <fileclose>
    return -1;
    80004fa8:	57fd                	li	a5,-1
}
    80004faa:	853e                	mv	a0,a5
    80004fac:	70e2                	ld	ra,56(sp)
    80004fae:	7442                	ld	s0,48(sp)
    80004fb0:	74a2                	ld	s1,40(sp)
    80004fb2:	6121                	addi	sp,sp,64
    80004fb4:	8082                	ret
	...

0000000080004fc0 <kernelvec>:
    80004fc0:	7111                	addi	sp,sp,-256
    80004fc2:	e006                	sd	ra,0(sp)
    80004fc4:	e40a                	sd	sp,8(sp)
    80004fc6:	e80e                	sd	gp,16(sp)
    80004fc8:	ec12                	sd	tp,24(sp)
    80004fca:	f016                	sd	t0,32(sp)
    80004fcc:	f41a                	sd	t1,40(sp)
    80004fce:	f81e                	sd	t2,48(sp)
    80004fd0:	fc22                	sd	s0,56(sp)
    80004fd2:	e0a6                	sd	s1,64(sp)
    80004fd4:	e4aa                	sd	a0,72(sp)
    80004fd6:	e8ae                	sd	a1,80(sp)
    80004fd8:	ecb2                	sd	a2,88(sp)
    80004fda:	f0b6                	sd	a3,96(sp)
    80004fdc:	f4ba                	sd	a4,104(sp)
    80004fde:	f8be                	sd	a5,112(sp)
    80004fe0:	fcc2                	sd	a6,120(sp)
    80004fe2:	e146                	sd	a7,128(sp)
    80004fe4:	e54a                	sd	s2,136(sp)
    80004fe6:	e94e                	sd	s3,144(sp)
    80004fe8:	ed52                	sd	s4,152(sp)
    80004fea:	f156                	sd	s5,160(sp)
    80004fec:	f55a                	sd	s6,168(sp)
    80004fee:	f95e                	sd	s7,176(sp)
    80004ff0:	fd62                	sd	s8,184(sp)
    80004ff2:	e1e6                	sd	s9,192(sp)
    80004ff4:	e5ea                	sd	s10,200(sp)
    80004ff6:	e9ee                	sd	s11,208(sp)
    80004ff8:	edf2                	sd	t3,216(sp)
    80004ffa:	f1f6                	sd	t4,224(sp)
    80004ffc:	f5fa                	sd	t5,232(sp)
    80004ffe:	f9fe                	sd	t6,240(sp)
    80005000:	d95fc0ef          	jal	ra,80001d94 <kerneltrap>
    80005004:	6082                	ld	ra,0(sp)
    80005006:	6122                	ld	sp,8(sp)
    80005008:	61c2                	ld	gp,16(sp)
    8000500a:	7282                	ld	t0,32(sp)
    8000500c:	7322                	ld	t1,40(sp)
    8000500e:	73c2                	ld	t2,48(sp)
    80005010:	7462                	ld	s0,56(sp)
    80005012:	6486                	ld	s1,64(sp)
    80005014:	6526                	ld	a0,72(sp)
    80005016:	65c6                	ld	a1,80(sp)
    80005018:	6666                	ld	a2,88(sp)
    8000501a:	7686                	ld	a3,96(sp)
    8000501c:	7726                	ld	a4,104(sp)
    8000501e:	77c6                	ld	a5,112(sp)
    80005020:	7866                	ld	a6,120(sp)
    80005022:	688a                	ld	a7,128(sp)
    80005024:	692a                	ld	s2,136(sp)
    80005026:	69ca                	ld	s3,144(sp)
    80005028:	6a6a                	ld	s4,152(sp)
    8000502a:	7a8a                	ld	s5,160(sp)
    8000502c:	7b2a                	ld	s6,168(sp)
    8000502e:	7bca                	ld	s7,176(sp)
    80005030:	7c6a                	ld	s8,184(sp)
    80005032:	6c8e                	ld	s9,192(sp)
    80005034:	6d2e                	ld	s10,200(sp)
    80005036:	6dce                	ld	s11,208(sp)
    80005038:	6e6e                	ld	t3,216(sp)
    8000503a:	7e8e                	ld	t4,224(sp)
    8000503c:	7f2e                	ld	t5,232(sp)
    8000503e:	7fce                	ld	t6,240(sp)
    80005040:	6111                	addi	sp,sp,256
    80005042:	10200073          	sret
    80005046:	00000013          	nop
    8000504a:	00000013          	nop
    8000504e:	0001                	nop

0000000080005050 <timervec>:
    80005050:	34051573          	csrrw	a0,mscratch,a0
    80005054:	e10c                	sd	a1,0(a0)
    80005056:	e510                	sd	a2,8(a0)
    80005058:	e914                	sd	a3,16(a0)
    8000505a:	6d0c                	ld	a1,24(a0)
    8000505c:	7110                	ld	a2,32(a0)
    8000505e:	6194                	ld	a3,0(a1)
    80005060:	96b2                	add	a3,a3,a2
    80005062:	e194                	sd	a3,0(a1)
    80005064:	4589                	li	a1,2
    80005066:	14459073          	csrw	sip,a1
    8000506a:	6914                	ld	a3,16(a0)
    8000506c:	6510                	ld	a2,8(a0)
    8000506e:	610c                	ld	a1,0(a0)
    80005070:	34051573          	csrrw	a0,mscratch,a0
    80005074:	30200073          	mret
	...

000000008000507a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000507a:	1141                	addi	sp,sp,-16
    8000507c:	e422                	sd	s0,8(sp)
    8000507e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005080:	0c0007b7          	lui	a5,0xc000
    80005084:	4705                	li	a4,1
    80005086:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005088:	c3d8                	sw	a4,4(a5)
}
    8000508a:	6422                	ld	s0,8(sp)
    8000508c:	0141                	addi	sp,sp,16
    8000508e:	8082                	ret

0000000080005090 <plicinithart>:

void
plicinithart(void)
{
    80005090:	1141                	addi	sp,sp,-16
    80005092:	e406                	sd	ra,8(sp)
    80005094:	e022                	sd	s0,0(sp)
    80005096:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	d8e080e7          	jalr	-626(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050a0:	0085171b          	slliw	a4,a0,0x8
    800050a4:	0c0027b7          	lui	a5,0xc002
    800050a8:	97ba                	add	a5,a5,a4
    800050aa:	40200713          	li	a4,1026
    800050ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050b2:	00d5151b          	slliw	a0,a0,0xd
    800050b6:	0c2017b7          	lui	a5,0xc201
    800050ba:	953e                	add	a0,a0,a5
    800050bc:	00052023          	sw	zero,0(a0)
}
    800050c0:	60a2                	ld	ra,8(sp)
    800050c2:	6402                	ld	s0,0(sp)
    800050c4:	0141                	addi	sp,sp,16
    800050c6:	8082                	ret

00000000800050c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050c8:	1141                	addi	sp,sp,-16
    800050ca:	e406                	sd	ra,8(sp)
    800050cc:	e022                	sd	s0,0(sp)
    800050ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050d0:	ffffc097          	auipc	ra,0xffffc
    800050d4:	d56080e7          	jalr	-682(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050d8:	00d5179b          	slliw	a5,a0,0xd
    800050dc:	0c201537          	lui	a0,0xc201
    800050e0:	953e                	add	a0,a0,a5
  return irq;
}
    800050e2:	4148                	lw	a0,4(a0)
    800050e4:	60a2                	ld	ra,8(sp)
    800050e6:	6402                	ld	s0,0(sp)
    800050e8:	0141                	addi	sp,sp,16
    800050ea:	8082                	ret

00000000800050ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050ec:	1101                	addi	sp,sp,-32
    800050ee:	ec06                	sd	ra,24(sp)
    800050f0:	e822                	sd	s0,16(sp)
    800050f2:	e426                	sd	s1,8(sp)
    800050f4:	1000                	addi	s0,sp,32
    800050f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	d2e080e7          	jalr	-722(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005100:	00d5151b          	slliw	a0,a0,0xd
    80005104:	0c2017b7          	lui	a5,0xc201
    80005108:	97aa                	add	a5,a5,a0
    8000510a:	c3c4                	sw	s1,4(a5)
}
    8000510c:	60e2                	ld	ra,24(sp)
    8000510e:	6442                	ld	s0,16(sp)
    80005110:	64a2                	ld	s1,8(sp)
    80005112:	6105                	addi	sp,sp,32
    80005114:	8082                	ret

0000000080005116 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005116:	1141                	addi	sp,sp,-16
    80005118:	e406                	sd	ra,8(sp)
    8000511a:	e022                	sd	s0,0(sp)
    8000511c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000511e:	479d                	li	a5,7
    80005120:	04a7cc63          	blt	a5,a0,80005178 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005124:	00015797          	auipc	a5,0x15
    80005128:	88c78793          	addi	a5,a5,-1908 # 800199b0 <disk>
    8000512c:	97aa                	add	a5,a5,a0
    8000512e:	0187c783          	lbu	a5,24(a5)
    80005132:	ebb9                	bnez	a5,80005188 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005134:	00451613          	slli	a2,a0,0x4
    80005138:	00015797          	auipc	a5,0x15
    8000513c:	87878793          	addi	a5,a5,-1928 # 800199b0 <disk>
    80005140:	6394                	ld	a3,0(a5)
    80005142:	96b2                	add	a3,a3,a2
    80005144:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005148:	6398                	ld	a4,0(a5)
    8000514a:	9732                	add	a4,a4,a2
    8000514c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005150:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005154:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005158:	953e                	add	a0,a0,a5
    8000515a:	4785                	li	a5,1
    8000515c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005160:	00015517          	auipc	a0,0x15
    80005164:	86850513          	addi	a0,a0,-1944 # 800199c8 <disk+0x18>
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	3f6080e7          	jalr	1014(ra) # 8000155e <wakeup>
}
    80005170:	60a2                	ld	ra,8(sp)
    80005172:	6402                	ld	s0,0(sp)
    80005174:	0141                	addi	sp,sp,16
    80005176:	8082                	ret
    panic("free_desc 1");
    80005178:	00003517          	auipc	a0,0x3
    8000517c:	54850513          	addi	a0,a0,1352 # 800086c0 <syscalls+0x2f0>
    80005180:	00001097          	auipc	ra,0x1
    80005184:	a0e080e7          	jalr	-1522(ra) # 80005b8e <panic>
    panic("free_desc 2");
    80005188:	00003517          	auipc	a0,0x3
    8000518c:	54850513          	addi	a0,a0,1352 # 800086d0 <syscalls+0x300>
    80005190:	00001097          	auipc	ra,0x1
    80005194:	9fe080e7          	jalr	-1538(ra) # 80005b8e <panic>

0000000080005198 <virtio_disk_init>:
{
    80005198:	1101                	addi	sp,sp,-32
    8000519a:	ec06                	sd	ra,24(sp)
    8000519c:	e822                	sd	s0,16(sp)
    8000519e:	e426                	sd	s1,8(sp)
    800051a0:	e04a                	sd	s2,0(sp)
    800051a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051a4:	00003597          	auipc	a1,0x3
    800051a8:	53c58593          	addi	a1,a1,1340 # 800086e0 <syscalls+0x310>
    800051ac:	00015517          	auipc	a0,0x15
    800051b0:	92c50513          	addi	a0,a0,-1748 # 80019ad8 <disk+0x128>
    800051b4:	00001097          	auipc	ra,0x1
    800051b8:	e86080e7          	jalr	-378(ra) # 8000603a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051bc:	100017b7          	lui	a5,0x10001
    800051c0:	4398                	lw	a4,0(a5)
    800051c2:	2701                	sext.w	a4,a4
    800051c4:	747277b7          	lui	a5,0x74727
    800051c8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051cc:	14f71c63          	bne	a4,a5,80005324 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051d0:	100017b7          	lui	a5,0x10001
    800051d4:	43dc                	lw	a5,4(a5)
    800051d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051d8:	4709                	li	a4,2
    800051da:	14e79563          	bne	a5,a4,80005324 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051de:	100017b7          	lui	a5,0x10001
    800051e2:	479c                	lw	a5,8(a5)
    800051e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051e6:	12e79f63          	bne	a5,a4,80005324 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051ea:	100017b7          	lui	a5,0x10001
    800051ee:	47d8                	lw	a4,12(a5)
    800051f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051f2:	554d47b7          	lui	a5,0x554d4
    800051f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051fa:	12f71563          	bne	a4,a5,80005324 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051fe:	100017b7          	lui	a5,0x10001
    80005202:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005206:	4705                	li	a4,1
    80005208:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520a:	470d                	li	a4,3
    8000520c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000520e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005210:	c7ffe737          	lui	a4,0xc7ffe
    80005214:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca2f>
    80005218:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000521a:	2701                	sext.w	a4,a4
    8000521c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000521e:	472d                	li	a4,11
    80005220:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005222:	5bbc                	lw	a5,112(a5)
    80005224:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005228:	8ba1                	andi	a5,a5,8
    8000522a:	10078563          	beqz	a5,80005334 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000522e:	100017b7          	lui	a5,0x10001
    80005232:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005236:	43fc                	lw	a5,68(a5)
    80005238:	2781                	sext.w	a5,a5
    8000523a:	10079563          	bnez	a5,80005344 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000523e:	100017b7          	lui	a5,0x10001
    80005242:	5bdc                	lw	a5,52(a5)
    80005244:	2781                	sext.w	a5,a5
  if(max == 0)
    80005246:	10078763          	beqz	a5,80005354 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000524a:	471d                	li	a4,7
    8000524c:	10f77c63          	bgeu	a4,a5,80005364 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005250:	ffffb097          	auipc	ra,0xffffb
    80005254:	ec8080e7          	jalr	-312(ra) # 80000118 <kalloc>
    80005258:	00014497          	auipc	s1,0x14
    8000525c:	75848493          	addi	s1,s1,1880 # 800199b0 <disk>
    80005260:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005262:	ffffb097          	auipc	ra,0xffffb
    80005266:	eb6080e7          	jalr	-330(ra) # 80000118 <kalloc>
    8000526a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000526c:	ffffb097          	auipc	ra,0xffffb
    80005270:	eac080e7          	jalr	-340(ra) # 80000118 <kalloc>
    80005274:	87aa                	mv	a5,a0
    80005276:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005278:	6088                	ld	a0,0(s1)
    8000527a:	cd6d                	beqz	a0,80005374 <virtio_disk_init+0x1dc>
    8000527c:	00014717          	auipc	a4,0x14
    80005280:	73c73703          	ld	a4,1852(a4) # 800199b8 <disk+0x8>
    80005284:	cb65                	beqz	a4,80005374 <virtio_disk_init+0x1dc>
    80005286:	c7fd                	beqz	a5,80005374 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005288:	6605                	lui	a2,0x1
    8000528a:	4581                	li	a1,0
    8000528c:	ffffb097          	auipc	ra,0xffffb
    80005290:	eec080e7          	jalr	-276(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005294:	00014497          	auipc	s1,0x14
    80005298:	71c48493          	addi	s1,s1,1820 # 800199b0 <disk>
    8000529c:	6605                	lui	a2,0x1
    8000529e:	4581                	li	a1,0
    800052a0:	6488                	ld	a0,8(s1)
    800052a2:	ffffb097          	auipc	ra,0xffffb
    800052a6:	ed6080e7          	jalr	-298(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    800052aa:	6605                	lui	a2,0x1
    800052ac:	4581                	li	a1,0
    800052ae:	6888                	ld	a0,16(s1)
    800052b0:	ffffb097          	auipc	ra,0xffffb
    800052b4:	ec8080e7          	jalr	-312(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	4721                	li	a4,8
    800052be:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052c0:	4098                	lw	a4,0(s1)
    800052c2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052c6:	40d8                	lw	a4,4(s1)
    800052c8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052cc:	6498                	ld	a4,8(s1)
    800052ce:	0007069b          	sext.w	a3,a4
    800052d2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052d6:	9701                	srai	a4,a4,0x20
    800052d8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052dc:	6898                	ld	a4,16(s1)
    800052de:	0007069b          	sext.w	a3,a4
    800052e2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052e6:	9701                	srai	a4,a4,0x20
    800052e8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052ec:	4705                	li	a4,1
    800052ee:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052f0:	00e48c23          	sb	a4,24(s1)
    800052f4:	00e48ca3          	sb	a4,25(s1)
    800052f8:	00e48d23          	sb	a4,26(s1)
    800052fc:	00e48da3          	sb	a4,27(s1)
    80005300:	00e48e23          	sb	a4,28(s1)
    80005304:	00e48ea3          	sb	a4,29(s1)
    80005308:	00e48f23          	sb	a4,30(s1)
    8000530c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005310:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005314:	0727a823          	sw	s2,112(a5)
}
    80005318:	60e2                	ld	ra,24(sp)
    8000531a:	6442                	ld	s0,16(sp)
    8000531c:	64a2                	ld	s1,8(sp)
    8000531e:	6902                	ld	s2,0(sp)
    80005320:	6105                	addi	sp,sp,32
    80005322:	8082                	ret
    panic("could not find virtio disk");
    80005324:	00003517          	auipc	a0,0x3
    80005328:	3cc50513          	addi	a0,a0,972 # 800086f0 <syscalls+0x320>
    8000532c:	00001097          	auipc	ra,0x1
    80005330:	862080e7          	jalr	-1950(ra) # 80005b8e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005334:	00003517          	auipc	a0,0x3
    80005338:	3dc50513          	addi	a0,a0,988 # 80008710 <syscalls+0x340>
    8000533c:	00001097          	auipc	ra,0x1
    80005340:	852080e7          	jalr	-1966(ra) # 80005b8e <panic>
    panic("virtio disk should not be ready");
    80005344:	00003517          	auipc	a0,0x3
    80005348:	3ec50513          	addi	a0,a0,1004 # 80008730 <syscalls+0x360>
    8000534c:	00001097          	auipc	ra,0x1
    80005350:	842080e7          	jalr	-1982(ra) # 80005b8e <panic>
    panic("virtio disk has no queue 0");
    80005354:	00003517          	auipc	a0,0x3
    80005358:	3fc50513          	addi	a0,a0,1020 # 80008750 <syscalls+0x380>
    8000535c:	00001097          	auipc	ra,0x1
    80005360:	832080e7          	jalr	-1998(ra) # 80005b8e <panic>
    panic("virtio disk max queue too short");
    80005364:	00003517          	auipc	a0,0x3
    80005368:	40c50513          	addi	a0,a0,1036 # 80008770 <syscalls+0x3a0>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	822080e7          	jalr	-2014(ra) # 80005b8e <panic>
    panic("virtio disk kalloc");
    80005374:	00003517          	auipc	a0,0x3
    80005378:	41c50513          	addi	a0,a0,1052 # 80008790 <syscalls+0x3c0>
    8000537c:	00001097          	auipc	ra,0x1
    80005380:	812080e7          	jalr	-2030(ra) # 80005b8e <panic>

0000000080005384 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005384:	7119                	addi	sp,sp,-128
    80005386:	fc86                	sd	ra,120(sp)
    80005388:	f8a2                	sd	s0,112(sp)
    8000538a:	f4a6                	sd	s1,104(sp)
    8000538c:	f0ca                	sd	s2,96(sp)
    8000538e:	ecce                	sd	s3,88(sp)
    80005390:	e8d2                	sd	s4,80(sp)
    80005392:	e4d6                	sd	s5,72(sp)
    80005394:	e0da                	sd	s6,64(sp)
    80005396:	fc5e                	sd	s7,56(sp)
    80005398:	f862                	sd	s8,48(sp)
    8000539a:	f466                	sd	s9,40(sp)
    8000539c:	f06a                	sd	s10,32(sp)
    8000539e:	ec6e                	sd	s11,24(sp)
    800053a0:	0100                	addi	s0,sp,128
    800053a2:	8aaa                	mv	s5,a0
    800053a4:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053a6:	00c52d03          	lw	s10,12(a0)
    800053aa:	001d1d1b          	slliw	s10,s10,0x1
    800053ae:	1d02                	slli	s10,s10,0x20
    800053b0:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800053b4:	00014517          	auipc	a0,0x14
    800053b8:	72450513          	addi	a0,a0,1828 # 80019ad8 <disk+0x128>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	d0e080e7          	jalr	-754(ra) # 800060ca <acquire>
  for(int i = 0; i < 3; i++){
    800053c4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053c6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053c8:	00014b97          	auipc	s7,0x14
    800053cc:	5e8b8b93          	addi	s7,s7,1512 # 800199b0 <disk>
  for(int i = 0; i < 3; i++){
    800053d0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053d2:	00014c97          	auipc	s9,0x14
    800053d6:	706c8c93          	addi	s9,s9,1798 # 80019ad8 <disk+0x128>
    800053da:	a08d                	j	8000543c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800053dc:	00fb8733          	add	a4,s7,a5
    800053e0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053e4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053e6:	0207c563          	bltz	a5,80005410 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800053ea:	2905                	addiw	s2,s2,1
    800053ec:	0611                	addi	a2,a2,4
    800053ee:	05690c63          	beq	s2,s6,80005446 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800053f2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053f4:	00014717          	auipc	a4,0x14
    800053f8:	5bc70713          	addi	a4,a4,1468 # 800199b0 <disk>
    800053fc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053fe:	01874683          	lbu	a3,24(a4)
    80005402:	fee9                	bnez	a3,800053dc <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005404:	2785                	addiw	a5,a5,1
    80005406:	0705                	addi	a4,a4,1
    80005408:	fe979be3          	bne	a5,s1,800053fe <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000540c:	57fd                	li	a5,-1
    8000540e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005410:	01205d63          	blez	s2,8000542a <virtio_disk_rw+0xa6>
    80005414:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005416:	000a2503          	lw	a0,0(s4)
    8000541a:	00000097          	auipc	ra,0x0
    8000541e:	cfc080e7          	jalr	-772(ra) # 80005116 <free_desc>
      for(int j = 0; j < i; j++)
    80005422:	2d85                	addiw	s11,s11,1
    80005424:	0a11                	addi	s4,s4,4
    80005426:	ffb918e3          	bne	s2,s11,80005416 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000542a:	85e6                	mv	a1,s9
    8000542c:	00014517          	auipc	a0,0x14
    80005430:	59c50513          	addi	a0,a0,1436 # 800199c8 <disk+0x18>
    80005434:	ffffc097          	auipc	ra,0xffffc
    80005438:	0c6080e7          	jalr	198(ra) # 800014fa <sleep>
  for(int i = 0; i < 3; i++){
    8000543c:	f8040a13          	addi	s4,s0,-128
{
    80005440:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005442:	894e                	mv	s2,s3
    80005444:	b77d                	j	800053f2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005446:	f8042583          	lw	a1,-128(s0)
    8000544a:	00a58793          	addi	a5,a1,10
    8000544e:	0792                	slli	a5,a5,0x4

  if(write)
    80005450:	00014617          	auipc	a2,0x14
    80005454:	56060613          	addi	a2,a2,1376 # 800199b0 <disk>
    80005458:	00f60733          	add	a4,a2,a5
    8000545c:	018036b3          	snez	a3,s8
    80005460:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005462:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005466:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000546a:	f6078693          	addi	a3,a5,-160
    8000546e:	6218                	ld	a4,0(a2)
    80005470:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005472:	00878513          	addi	a0,a5,8
    80005476:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005478:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000547a:	6208                	ld	a0,0(a2)
    8000547c:	96aa                	add	a3,a3,a0
    8000547e:	4741                	li	a4,16
    80005480:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005482:	4705                	li	a4,1
    80005484:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005488:	f8442703          	lw	a4,-124(s0)
    8000548c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005490:	0712                	slli	a4,a4,0x4
    80005492:	953a                	add	a0,a0,a4
    80005494:	058a8693          	addi	a3,s5,88
    80005498:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000549a:	6208                	ld	a0,0(a2)
    8000549c:	972a                	add	a4,a4,a0
    8000549e:	40000693          	li	a3,1024
    800054a2:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800054a4:	001c3c13          	seqz	s8,s8
    800054a8:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054aa:	001c6c13          	ori	s8,s8,1
    800054ae:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800054b2:	f8842603          	lw	a2,-120(s0)
    800054b6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054ba:	00014697          	auipc	a3,0x14
    800054be:	4f668693          	addi	a3,a3,1270 # 800199b0 <disk>
    800054c2:	00258713          	addi	a4,a1,2
    800054c6:	0712                	slli	a4,a4,0x4
    800054c8:	9736                	add	a4,a4,a3
    800054ca:	587d                	li	a6,-1
    800054cc:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054d0:	0612                	slli	a2,a2,0x4
    800054d2:	9532                	add	a0,a0,a2
    800054d4:	f9078793          	addi	a5,a5,-112
    800054d8:	97b6                	add	a5,a5,a3
    800054da:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800054dc:	629c                	ld	a5,0(a3)
    800054de:	97b2                	add	a5,a5,a2
    800054e0:	4605                	li	a2,1
    800054e2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054e4:	4509                	li	a0,2
    800054e6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800054ea:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054ee:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800054f2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054f6:	6698                	ld	a4,8(a3)
    800054f8:	00275783          	lhu	a5,2(a4)
    800054fc:	8b9d                	andi	a5,a5,7
    800054fe:	0786                	slli	a5,a5,0x1
    80005500:	97ba                	add	a5,a5,a4
    80005502:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005506:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000550a:	6698                	ld	a4,8(a3)
    8000550c:	00275783          	lhu	a5,2(a4)
    80005510:	2785                	addiw	a5,a5,1
    80005512:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005516:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000551a:	100017b7          	lui	a5,0x10001
    8000551e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005522:	004aa783          	lw	a5,4(s5)
    80005526:	02c79163          	bne	a5,a2,80005548 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000552a:	00014917          	auipc	s2,0x14
    8000552e:	5ae90913          	addi	s2,s2,1454 # 80019ad8 <disk+0x128>
  while(b->disk == 1) {
    80005532:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005534:	85ca                	mv	a1,s2
    80005536:	8556                	mv	a0,s5
    80005538:	ffffc097          	auipc	ra,0xffffc
    8000553c:	fc2080e7          	jalr	-62(ra) # 800014fa <sleep>
  while(b->disk == 1) {
    80005540:	004aa783          	lw	a5,4(s5)
    80005544:	fe9788e3          	beq	a5,s1,80005534 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005548:	f8042903          	lw	s2,-128(s0)
    8000554c:	00290793          	addi	a5,s2,2
    80005550:	00479713          	slli	a4,a5,0x4
    80005554:	00014797          	auipc	a5,0x14
    80005558:	45c78793          	addi	a5,a5,1116 # 800199b0 <disk>
    8000555c:	97ba                	add	a5,a5,a4
    8000555e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005562:	00014997          	auipc	s3,0x14
    80005566:	44e98993          	addi	s3,s3,1102 # 800199b0 <disk>
    8000556a:	00491713          	slli	a4,s2,0x4
    8000556e:	0009b783          	ld	a5,0(s3)
    80005572:	97ba                	add	a5,a5,a4
    80005574:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005578:	854a                	mv	a0,s2
    8000557a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000557e:	00000097          	auipc	ra,0x0
    80005582:	b98080e7          	jalr	-1128(ra) # 80005116 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005586:	8885                	andi	s1,s1,1
    80005588:	f0ed                	bnez	s1,8000556a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000558a:	00014517          	auipc	a0,0x14
    8000558e:	54e50513          	addi	a0,a0,1358 # 80019ad8 <disk+0x128>
    80005592:	00001097          	auipc	ra,0x1
    80005596:	bec080e7          	jalr	-1044(ra) # 8000617e <release>
}
    8000559a:	70e6                	ld	ra,120(sp)
    8000559c:	7446                	ld	s0,112(sp)
    8000559e:	74a6                	ld	s1,104(sp)
    800055a0:	7906                	ld	s2,96(sp)
    800055a2:	69e6                	ld	s3,88(sp)
    800055a4:	6a46                	ld	s4,80(sp)
    800055a6:	6aa6                	ld	s5,72(sp)
    800055a8:	6b06                	ld	s6,64(sp)
    800055aa:	7be2                	ld	s7,56(sp)
    800055ac:	7c42                	ld	s8,48(sp)
    800055ae:	7ca2                	ld	s9,40(sp)
    800055b0:	7d02                	ld	s10,32(sp)
    800055b2:	6de2                	ld	s11,24(sp)
    800055b4:	6109                	addi	sp,sp,128
    800055b6:	8082                	ret

00000000800055b8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055b8:	1101                	addi	sp,sp,-32
    800055ba:	ec06                	sd	ra,24(sp)
    800055bc:	e822                	sd	s0,16(sp)
    800055be:	e426                	sd	s1,8(sp)
    800055c0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055c2:	00014497          	auipc	s1,0x14
    800055c6:	3ee48493          	addi	s1,s1,1006 # 800199b0 <disk>
    800055ca:	00014517          	auipc	a0,0x14
    800055ce:	50e50513          	addi	a0,a0,1294 # 80019ad8 <disk+0x128>
    800055d2:	00001097          	auipc	ra,0x1
    800055d6:	af8080e7          	jalr	-1288(ra) # 800060ca <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055da:	10001737          	lui	a4,0x10001
    800055de:	533c                	lw	a5,96(a4)
    800055e0:	8b8d                	andi	a5,a5,3
    800055e2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055e4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055e8:	689c                	ld	a5,16(s1)
    800055ea:	0204d703          	lhu	a4,32(s1)
    800055ee:	0027d783          	lhu	a5,2(a5)
    800055f2:	04f70863          	beq	a4,a5,80005642 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800055f6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055fa:	6898                	ld	a4,16(s1)
    800055fc:	0204d783          	lhu	a5,32(s1)
    80005600:	8b9d                	andi	a5,a5,7
    80005602:	078e                	slli	a5,a5,0x3
    80005604:	97ba                	add	a5,a5,a4
    80005606:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005608:	00278713          	addi	a4,a5,2
    8000560c:	0712                	slli	a4,a4,0x4
    8000560e:	9726                	add	a4,a4,s1
    80005610:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005614:	e721                	bnez	a4,8000565c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005616:	0789                	addi	a5,a5,2
    80005618:	0792                	slli	a5,a5,0x4
    8000561a:	97a6                	add	a5,a5,s1
    8000561c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000561e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005622:	ffffc097          	auipc	ra,0xffffc
    80005626:	f3c080e7          	jalr	-196(ra) # 8000155e <wakeup>

    disk.used_idx += 1;
    8000562a:	0204d783          	lhu	a5,32(s1)
    8000562e:	2785                	addiw	a5,a5,1
    80005630:	17c2                	slli	a5,a5,0x30
    80005632:	93c1                	srli	a5,a5,0x30
    80005634:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005638:	6898                	ld	a4,16(s1)
    8000563a:	00275703          	lhu	a4,2(a4)
    8000563e:	faf71ce3          	bne	a4,a5,800055f6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005642:	00014517          	auipc	a0,0x14
    80005646:	49650513          	addi	a0,a0,1174 # 80019ad8 <disk+0x128>
    8000564a:	00001097          	auipc	ra,0x1
    8000564e:	b34080e7          	jalr	-1228(ra) # 8000617e <release>
}
    80005652:	60e2                	ld	ra,24(sp)
    80005654:	6442                	ld	s0,16(sp)
    80005656:	64a2                	ld	s1,8(sp)
    80005658:	6105                	addi	sp,sp,32
    8000565a:	8082                	ret
      panic("virtio_disk_intr status");
    8000565c:	00003517          	auipc	a0,0x3
    80005660:	14c50513          	addi	a0,a0,332 # 800087a8 <syscalls+0x3d8>
    80005664:	00000097          	auipc	ra,0x0
    80005668:	52a080e7          	jalr	1322(ra) # 80005b8e <panic>

000000008000566c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000566c:	1141                	addi	sp,sp,-16
    8000566e:	e422                	sd	s0,8(sp)
    80005670:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005672:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005676:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000567a:	0037979b          	slliw	a5,a5,0x3
    8000567e:	02004737          	lui	a4,0x2004
    80005682:	97ba                	add	a5,a5,a4
    80005684:	0200c737          	lui	a4,0x200c
    80005688:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000568c:	000f4637          	lui	a2,0xf4
    80005690:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005694:	95b2                	add	a1,a1,a2
    80005696:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005698:	00269713          	slli	a4,a3,0x2
    8000569c:	9736                	add	a4,a4,a3
    8000569e:	00371693          	slli	a3,a4,0x3
    800056a2:	00014717          	auipc	a4,0x14
    800056a6:	44e70713          	addi	a4,a4,1102 # 80019af0 <timer_scratch>
    800056aa:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056ac:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056ae:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056b0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056b4:	00000797          	auipc	a5,0x0
    800056b8:	99c78793          	addi	a5,a5,-1636 # 80005050 <timervec>
    800056bc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056c0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056c4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056c8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056cc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056d0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056d4:	30479073          	csrw	mie,a5
}
    800056d8:	6422                	ld	s0,8(sp)
    800056da:	0141                	addi	sp,sp,16
    800056dc:	8082                	ret

00000000800056de <start>:
{
    800056de:	1141                	addi	sp,sp,-16
    800056e0:	e406                	sd	ra,8(sp)
    800056e2:	e022                	sd	s0,0(sp)
    800056e4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056e6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056ea:	7779                	lui	a4,0xffffe
    800056ec:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcacf>
    800056f0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056f2:	6705                	lui	a4,0x1
    800056f4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800056f8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056fa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800056fe:	ffffb797          	auipc	a5,0xffffb
    80005702:	c2078793          	addi	a5,a5,-992 # 8000031e <main>
    80005706:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000570a:	4781                	li	a5,0
    8000570c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005710:	67c1                	lui	a5,0x10
    80005712:	17fd                	addi	a5,a5,-1
    80005714:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005718:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000571c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005720:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005724:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005728:	57fd                	li	a5,-1
    8000572a:	83a9                	srli	a5,a5,0xa
    8000572c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005730:	47bd                	li	a5,15
    80005732:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005736:	00000097          	auipc	ra,0x0
    8000573a:	f36080e7          	jalr	-202(ra) # 8000566c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000573e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005742:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005744:	823e                	mv	tp,a5
  asm volatile("mret");
    80005746:	30200073          	mret
}
    8000574a:	60a2                	ld	ra,8(sp)
    8000574c:	6402                	ld	s0,0(sp)
    8000574e:	0141                	addi	sp,sp,16
    80005750:	8082                	ret

0000000080005752 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005752:	715d                	addi	sp,sp,-80
    80005754:	e486                	sd	ra,72(sp)
    80005756:	e0a2                	sd	s0,64(sp)
    80005758:	fc26                	sd	s1,56(sp)
    8000575a:	f84a                	sd	s2,48(sp)
    8000575c:	f44e                	sd	s3,40(sp)
    8000575e:	f052                	sd	s4,32(sp)
    80005760:	ec56                	sd	s5,24(sp)
    80005762:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005764:	04c05663          	blez	a2,800057b0 <consolewrite+0x5e>
    80005768:	8a2a                	mv	s4,a0
    8000576a:	84ae                	mv	s1,a1
    8000576c:	89b2                	mv	s3,a2
    8000576e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005770:	5afd                	li	s5,-1
    80005772:	4685                	li	a3,1
    80005774:	8626                	mv	a2,s1
    80005776:	85d2                	mv	a1,s4
    80005778:	fbf40513          	addi	a0,s0,-65
    8000577c:	ffffc097          	auipc	ra,0xffffc
    80005780:	1dc080e7          	jalr	476(ra) # 80001958 <either_copyin>
    80005784:	01550c63          	beq	a0,s5,8000579c <consolewrite+0x4a>
      break;
    uartputc(c);
    80005788:	fbf44503          	lbu	a0,-65(s0)
    8000578c:	00000097          	auipc	ra,0x0
    80005790:	780080e7          	jalr	1920(ra) # 80005f0c <uartputc>
  for(i = 0; i < n; i++){
    80005794:	2905                	addiw	s2,s2,1
    80005796:	0485                	addi	s1,s1,1
    80005798:	fd299de3          	bne	s3,s2,80005772 <consolewrite+0x20>
  }

  return i;
}
    8000579c:	854a                	mv	a0,s2
    8000579e:	60a6                	ld	ra,72(sp)
    800057a0:	6406                	ld	s0,64(sp)
    800057a2:	74e2                	ld	s1,56(sp)
    800057a4:	7942                	ld	s2,48(sp)
    800057a6:	79a2                	ld	s3,40(sp)
    800057a8:	7a02                	ld	s4,32(sp)
    800057aa:	6ae2                	ld	s5,24(sp)
    800057ac:	6161                	addi	sp,sp,80
    800057ae:	8082                	ret
  for(i = 0; i < n; i++){
    800057b0:	4901                	li	s2,0
    800057b2:	b7ed                	j	8000579c <consolewrite+0x4a>

00000000800057b4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057b4:	7159                	addi	sp,sp,-112
    800057b6:	f486                	sd	ra,104(sp)
    800057b8:	f0a2                	sd	s0,96(sp)
    800057ba:	eca6                	sd	s1,88(sp)
    800057bc:	e8ca                	sd	s2,80(sp)
    800057be:	e4ce                	sd	s3,72(sp)
    800057c0:	e0d2                	sd	s4,64(sp)
    800057c2:	fc56                	sd	s5,56(sp)
    800057c4:	f85a                	sd	s6,48(sp)
    800057c6:	f45e                	sd	s7,40(sp)
    800057c8:	f062                	sd	s8,32(sp)
    800057ca:	ec66                	sd	s9,24(sp)
    800057cc:	e86a                	sd	s10,16(sp)
    800057ce:	1880                	addi	s0,sp,112
    800057d0:	8aaa                	mv	s5,a0
    800057d2:	8a2e                	mv	s4,a1
    800057d4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057d6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800057da:	0001c517          	auipc	a0,0x1c
    800057de:	45650513          	addi	a0,a0,1110 # 80021c30 <cons>
    800057e2:	00001097          	auipc	ra,0x1
    800057e6:	8e8080e7          	jalr	-1816(ra) # 800060ca <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057ea:	0001c497          	auipc	s1,0x1c
    800057ee:	44648493          	addi	s1,s1,1094 # 80021c30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057f2:	0001c917          	auipc	s2,0x1c
    800057f6:	4d690913          	addi	s2,s2,1238 # 80021cc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800057fa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057fc:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800057fe:	4ca9                	li	s9,10
  while(n > 0){
    80005800:	07305b63          	blez	s3,80005876 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005804:	0984a783          	lw	a5,152(s1)
    80005808:	09c4a703          	lw	a4,156(s1)
    8000580c:	02f71763          	bne	a4,a5,8000583a <consoleread+0x86>
      if(killed(myproc())){
    80005810:	ffffb097          	auipc	ra,0xffffb
    80005814:	642080e7          	jalr	1602(ra) # 80000e52 <myproc>
    80005818:	ffffc097          	auipc	ra,0xffffc
    8000581c:	f8a080e7          	jalr	-118(ra) # 800017a2 <killed>
    80005820:	e535                	bnez	a0,8000588c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005822:	85a6                	mv	a1,s1
    80005824:	854a                	mv	a0,s2
    80005826:	ffffc097          	auipc	ra,0xffffc
    8000582a:	cd4080e7          	jalr	-812(ra) # 800014fa <sleep>
    while(cons.r == cons.w){
    8000582e:	0984a783          	lw	a5,152(s1)
    80005832:	09c4a703          	lw	a4,156(s1)
    80005836:	fcf70de3          	beq	a4,a5,80005810 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000583a:	0017871b          	addiw	a4,a5,1
    8000583e:	08e4ac23          	sw	a4,152(s1)
    80005842:	07f7f713          	andi	a4,a5,127
    80005846:	9726                	add	a4,a4,s1
    80005848:	01874703          	lbu	a4,24(a4)
    8000584c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005850:	077d0563          	beq	s10,s7,800058ba <consoleread+0x106>
    cbuf = c;
    80005854:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005858:	4685                	li	a3,1
    8000585a:	f9f40613          	addi	a2,s0,-97
    8000585e:	85d2                	mv	a1,s4
    80005860:	8556                	mv	a0,s5
    80005862:	ffffc097          	auipc	ra,0xffffc
    80005866:	0a0080e7          	jalr	160(ra) # 80001902 <either_copyout>
    8000586a:	01850663          	beq	a0,s8,80005876 <consoleread+0xc2>
    dst++;
    8000586e:	0a05                	addi	s4,s4,1
    --n;
    80005870:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005872:	f99d17e3          	bne	s10,s9,80005800 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005876:	0001c517          	auipc	a0,0x1c
    8000587a:	3ba50513          	addi	a0,a0,954 # 80021c30 <cons>
    8000587e:	00001097          	auipc	ra,0x1
    80005882:	900080e7          	jalr	-1792(ra) # 8000617e <release>

  return target - n;
    80005886:	413b053b          	subw	a0,s6,s3
    8000588a:	a811                	j	8000589e <consoleread+0xea>
        release(&cons.lock);
    8000588c:	0001c517          	auipc	a0,0x1c
    80005890:	3a450513          	addi	a0,a0,932 # 80021c30 <cons>
    80005894:	00001097          	auipc	ra,0x1
    80005898:	8ea080e7          	jalr	-1814(ra) # 8000617e <release>
        return -1;
    8000589c:	557d                	li	a0,-1
}
    8000589e:	70a6                	ld	ra,104(sp)
    800058a0:	7406                	ld	s0,96(sp)
    800058a2:	64e6                	ld	s1,88(sp)
    800058a4:	6946                	ld	s2,80(sp)
    800058a6:	69a6                	ld	s3,72(sp)
    800058a8:	6a06                	ld	s4,64(sp)
    800058aa:	7ae2                	ld	s5,56(sp)
    800058ac:	7b42                	ld	s6,48(sp)
    800058ae:	7ba2                	ld	s7,40(sp)
    800058b0:	7c02                	ld	s8,32(sp)
    800058b2:	6ce2                	ld	s9,24(sp)
    800058b4:	6d42                	ld	s10,16(sp)
    800058b6:	6165                	addi	sp,sp,112
    800058b8:	8082                	ret
      if(n < target){
    800058ba:	0009871b          	sext.w	a4,s3
    800058be:	fb677ce3          	bgeu	a4,s6,80005876 <consoleread+0xc2>
        cons.r--;
    800058c2:	0001c717          	auipc	a4,0x1c
    800058c6:	40f72323          	sw	a5,1030(a4) # 80021cc8 <cons+0x98>
    800058ca:	b775                	j	80005876 <consoleread+0xc2>

00000000800058cc <consputc>:
{
    800058cc:	1141                	addi	sp,sp,-16
    800058ce:	e406                	sd	ra,8(sp)
    800058d0:	e022                	sd	s0,0(sp)
    800058d2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800058d4:	10000793          	li	a5,256
    800058d8:	00f50a63          	beq	a0,a5,800058ec <consputc+0x20>
    uartputc_sync(c);
    800058dc:	00000097          	auipc	ra,0x0
    800058e0:	55e080e7          	jalr	1374(ra) # 80005e3a <uartputc_sync>
}
    800058e4:	60a2                	ld	ra,8(sp)
    800058e6:	6402                	ld	s0,0(sp)
    800058e8:	0141                	addi	sp,sp,16
    800058ea:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058ec:	4521                	li	a0,8
    800058ee:	00000097          	auipc	ra,0x0
    800058f2:	54c080e7          	jalr	1356(ra) # 80005e3a <uartputc_sync>
    800058f6:	02000513          	li	a0,32
    800058fa:	00000097          	auipc	ra,0x0
    800058fe:	540080e7          	jalr	1344(ra) # 80005e3a <uartputc_sync>
    80005902:	4521                	li	a0,8
    80005904:	00000097          	auipc	ra,0x0
    80005908:	536080e7          	jalr	1334(ra) # 80005e3a <uartputc_sync>
    8000590c:	bfe1                	j	800058e4 <consputc+0x18>

000000008000590e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000590e:	1101                	addi	sp,sp,-32
    80005910:	ec06                	sd	ra,24(sp)
    80005912:	e822                	sd	s0,16(sp)
    80005914:	e426                	sd	s1,8(sp)
    80005916:	e04a                	sd	s2,0(sp)
    80005918:	1000                	addi	s0,sp,32
    8000591a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000591c:	0001c517          	auipc	a0,0x1c
    80005920:	31450513          	addi	a0,a0,788 # 80021c30 <cons>
    80005924:	00000097          	auipc	ra,0x0
    80005928:	7a6080e7          	jalr	1958(ra) # 800060ca <acquire>

  switch(c){
    8000592c:	47d5                	li	a5,21
    8000592e:	0af48663          	beq	s1,a5,800059da <consoleintr+0xcc>
    80005932:	0297ca63          	blt	a5,s1,80005966 <consoleintr+0x58>
    80005936:	47a1                	li	a5,8
    80005938:	0ef48763          	beq	s1,a5,80005a26 <consoleintr+0x118>
    8000593c:	47c1                	li	a5,16
    8000593e:	10f49a63          	bne	s1,a5,80005a52 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005942:	ffffc097          	auipc	ra,0xffffc
    80005946:	06c080e7          	jalr	108(ra) # 800019ae <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000594a:	0001c517          	auipc	a0,0x1c
    8000594e:	2e650513          	addi	a0,a0,742 # 80021c30 <cons>
    80005952:	00001097          	auipc	ra,0x1
    80005956:	82c080e7          	jalr	-2004(ra) # 8000617e <release>
}
    8000595a:	60e2                	ld	ra,24(sp)
    8000595c:	6442                	ld	s0,16(sp)
    8000595e:	64a2                	ld	s1,8(sp)
    80005960:	6902                	ld	s2,0(sp)
    80005962:	6105                	addi	sp,sp,32
    80005964:	8082                	ret
  switch(c){
    80005966:	07f00793          	li	a5,127
    8000596a:	0af48e63          	beq	s1,a5,80005a26 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000596e:	0001c717          	auipc	a4,0x1c
    80005972:	2c270713          	addi	a4,a4,706 # 80021c30 <cons>
    80005976:	0a072783          	lw	a5,160(a4)
    8000597a:	09872703          	lw	a4,152(a4)
    8000597e:	9f99                	subw	a5,a5,a4
    80005980:	07f00713          	li	a4,127
    80005984:	fcf763e3          	bltu	a4,a5,8000594a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005988:	47b5                	li	a5,13
    8000598a:	0cf48763          	beq	s1,a5,80005a58 <consoleintr+0x14a>
      consputc(c);
    8000598e:	8526                	mv	a0,s1
    80005990:	00000097          	auipc	ra,0x0
    80005994:	f3c080e7          	jalr	-196(ra) # 800058cc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005998:	0001c797          	auipc	a5,0x1c
    8000599c:	29878793          	addi	a5,a5,664 # 80021c30 <cons>
    800059a0:	0a07a683          	lw	a3,160(a5)
    800059a4:	0016871b          	addiw	a4,a3,1
    800059a8:	0007061b          	sext.w	a2,a4
    800059ac:	0ae7a023          	sw	a4,160(a5)
    800059b0:	07f6f693          	andi	a3,a3,127
    800059b4:	97b6                	add	a5,a5,a3
    800059b6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800059ba:	47a9                	li	a5,10
    800059bc:	0cf48563          	beq	s1,a5,80005a86 <consoleintr+0x178>
    800059c0:	4791                	li	a5,4
    800059c2:	0cf48263          	beq	s1,a5,80005a86 <consoleintr+0x178>
    800059c6:	0001c797          	auipc	a5,0x1c
    800059ca:	3027a783          	lw	a5,770(a5) # 80021cc8 <cons+0x98>
    800059ce:	9f1d                	subw	a4,a4,a5
    800059d0:	08000793          	li	a5,128
    800059d4:	f6f71be3          	bne	a4,a5,8000594a <consoleintr+0x3c>
    800059d8:	a07d                	j	80005a86 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059da:	0001c717          	auipc	a4,0x1c
    800059de:	25670713          	addi	a4,a4,598 # 80021c30 <cons>
    800059e2:	0a072783          	lw	a5,160(a4)
    800059e6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059ea:	0001c497          	auipc	s1,0x1c
    800059ee:	24648493          	addi	s1,s1,582 # 80021c30 <cons>
    while(cons.e != cons.w &&
    800059f2:	4929                	li	s2,10
    800059f4:	f4f70be3          	beq	a4,a5,8000594a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800059f8:	37fd                	addiw	a5,a5,-1
    800059fa:	07f7f713          	andi	a4,a5,127
    800059fe:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a00:	01874703          	lbu	a4,24(a4)
    80005a04:	f52703e3          	beq	a4,s2,8000594a <consoleintr+0x3c>
      cons.e--;
    80005a08:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a0c:	10000513          	li	a0,256
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	ebc080e7          	jalr	-324(ra) # 800058cc <consputc>
    while(cons.e != cons.w &&
    80005a18:	0a04a783          	lw	a5,160(s1)
    80005a1c:	09c4a703          	lw	a4,156(s1)
    80005a20:	fcf71ce3          	bne	a4,a5,800059f8 <consoleintr+0xea>
    80005a24:	b71d                	j	8000594a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a26:	0001c717          	auipc	a4,0x1c
    80005a2a:	20a70713          	addi	a4,a4,522 # 80021c30 <cons>
    80005a2e:	0a072783          	lw	a5,160(a4)
    80005a32:	09c72703          	lw	a4,156(a4)
    80005a36:	f0f70ae3          	beq	a4,a5,8000594a <consoleintr+0x3c>
      cons.e--;
    80005a3a:	37fd                	addiw	a5,a5,-1
    80005a3c:	0001c717          	auipc	a4,0x1c
    80005a40:	28f72a23          	sw	a5,660(a4) # 80021cd0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a44:	10000513          	li	a0,256
    80005a48:	00000097          	auipc	ra,0x0
    80005a4c:	e84080e7          	jalr	-380(ra) # 800058cc <consputc>
    80005a50:	bded                	j	8000594a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a52:	ee048ce3          	beqz	s1,8000594a <consoleintr+0x3c>
    80005a56:	bf21                	j	8000596e <consoleintr+0x60>
      consputc(c);
    80005a58:	4529                	li	a0,10
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	e72080e7          	jalr	-398(ra) # 800058cc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a62:	0001c797          	auipc	a5,0x1c
    80005a66:	1ce78793          	addi	a5,a5,462 # 80021c30 <cons>
    80005a6a:	0a07a703          	lw	a4,160(a5)
    80005a6e:	0017069b          	addiw	a3,a4,1
    80005a72:	0006861b          	sext.w	a2,a3
    80005a76:	0ad7a023          	sw	a3,160(a5)
    80005a7a:	07f77713          	andi	a4,a4,127
    80005a7e:	97ba                	add	a5,a5,a4
    80005a80:	4729                	li	a4,10
    80005a82:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a86:	0001c797          	auipc	a5,0x1c
    80005a8a:	24c7a323          	sw	a2,582(a5) # 80021ccc <cons+0x9c>
        wakeup(&cons.r);
    80005a8e:	0001c517          	auipc	a0,0x1c
    80005a92:	23a50513          	addi	a0,a0,570 # 80021cc8 <cons+0x98>
    80005a96:	ffffc097          	auipc	ra,0xffffc
    80005a9a:	ac8080e7          	jalr	-1336(ra) # 8000155e <wakeup>
    80005a9e:	b575                	j	8000594a <consoleintr+0x3c>

0000000080005aa0 <consoleinit>:

void
consoleinit(void)
{
    80005aa0:	1141                	addi	sp,sp,-16
    80005aa2:	e406                	sd	ra,8(sp)
    80005aa4:	e022                	sd	s0,0(sp)
    80005aa6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005aa8:	00003597          	auipc	a1,0x3
    80005aac:	d1858593          	addi	a1,a1,-744 # 800087c0 <syscalls+0x3f0>
    80005ab0:	0001c517          	auipc	a0,0x1c
    80005ab4:	18050513          	addi	a0,a0,384 # 80021c30 <cons>
    80005ab8:	00000097          	auipc	ra,0x0
    80005abc:	582080e7          	jalr	1410(ra) # 8000603a <initlock>

  uartinit();
    80005ac0:	00000097          	auipc	ra,0x0
    80005ac4:	32a080e7          	jalr	810(ra) # 80005dea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ac8:	00013797          	auipc	a5,0x13
    80005acc:	e9078793          	addi	a5,a5,-368 # 80018958 <devsw>
    80005ad0:	00000717          	auipc	a4,0x0
    80005ad4:	ce470713          	addi	a4,a4,-796 # 800057b4 <consoleread>
    80005ad8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ada:	00000717          	auipc	a4,0x0
    80005ade:	c7870713          	addi	a4,a4,-904 # 80005752 <consolewrite>
    80005ae2:	ef98                	sd	a4,24(a5)
}
    80005ae4:	60a2                	ld	ra,8(sp)
    80005ae6:	6402                	ld	s0,0(sp)
    80005ae8:	0141                	addi	sp,sp,16
    80005aea:	8082                	ret

0000000080005aec <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005aec:	7179                	addi	sp,sp,-48
    80005aee:	f406                	sd	ra,40(sp)
    80005af0:	f022                	sd	s0,32(sp)
    80005af2:	ec26                	sd	s1,24(sp)
    80005af4:	e84a                	sd	s2,16(sp)
    80005af6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005af8:	c219                	beqz	a2,80005afe <printint+0x12>
    80005afa:	08054663          	bltz	a0,80005b86 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005afe:	2501                	sext.w	a0,a0
    80005b00:	4881                	li	a7,0
    80005b02:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b06:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b08:	2581                	sext.w	a1,a1
    80005b0a:	00003617          	auipc	a2,0x3
    80005b0e:	ce660613          	addi	a2,a2,-794 # 800087f0 <digits>
    80005b12:	883a                	mv	a6,a4
    80005b14:	2705                	addiw	a4,a4,1
    80005b16:	02b577bb          	remuw	a5,a0,a1
    80005b1a:	1782                	slli	a5,a5,0x20
    80005b1c:	9381                	srli	a5,a5,0x20
    80005b1e:	97b2                	add	a5,a5,a2
    80005b20:	0007c783          	lbu	a5,0(a5)
    80005b24:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b28:	0005079b          	sext.w	a5,a0
    80005b2c:	02b5553b          	divuw	a0,a0,a1
    80005b30:	0685                	addi	a3,a3,1
    80005b32:	feb7f0e3          	bgeu	a5,a1,80005b12 <printint+0x26>

  if(sign)
    80005b36:	00088b63          	beqz	a7,80005b4c <printint+0x60>
    buf[i++] = '-';
    80005b3a:	fe040793          	addi	a5,s0,-32
    80005b3e:	973e                	add	a4,a4,a5
    80005b40:	02d00793          	li	a5,45
    80005b44:	fef70823          	sb	a5,-16(a4)
    80005b48:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b4c:	02e05763          	blez	a4,80005b7a <printint+0x8e>
    80005b50:	fd040793          	addi	a5,s0,-48
    80005b54:	00e784b3          	add	s1,a5,a4
    80005b58:	fff78913          	addi	s2,a5,-1
    80005b5c:	993a                	add	s2,s2,a4
    80005b5e:	377d                	addiw	a4,a4,-1
    80005b60:	1702                	slli	a4,a4,0x20
    80005b62:	9301                	srli	a4,a4,0x20
    80005b64:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b68:	fff4c503          	lbu	a0,-1(s1)
    80005b6c:	00000097          	auipc	ra,0x0
    80005b70:	d60080e7          	jalr	-672(ra) # 800058cc <consputc>
  while(--i >= 0)
    80005b74:	14fd                	addi	s1,s1,-1
    80005b76:	ff2499e3          	bne	s1,s2,80005b68 <printint+0x7c>
}
    80005b7a:	70a2                	ld	ra,40(sp)
    80005b7c:	7402                	ld	s0,32(sp)
    80005b7e:	64e2                	ld	s1,24(sp)
    80005b80:	6942                	ld	s2,16(sp)
    80005b82:	6145                	addi	sp,sp,48
    80005b84:	8082                	ret
    x = -xx;
    80005b86:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b8a:	4885                	li	a7,1
    x = -xx;
    80005b8c:	bf9d                	j	80005b02 <printint+0x16>

0000000080005b8e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b8e:	1101                	addi	sp,sp,-32
    80005b90:	ec06                	sd	ra,24(sp)
    80005b92:	e822                	sd	s0,16(sp)
    80005b94:	e426                	sd	s1,8(sp)
    80005b96:	1000                	addi	s0,sp,32
    80005b98:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b9a:	0001c797          	auipc	a5,0x1c
    80005b9e:	1407ab23          	sw	zero,342(a5) # 80021cf0 <pr+0x18>
  printf("panic: ");
    80005ba2:	00003517          	auipc	a0,0x3
    80005ba6:	c2650513          	addi	a0,a0,-986 # 800087c8 <syscalls+0x3f8>
    80005baa:	00000097          	auipc	ra,0x0
    80005bae:	02e080e7          	jalr	46(ra) # 80005bd8 <printf>
  printf(s);
    80005bb2:	8526                	mv	a0,s1
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	024080e7          	jalr	36(ra) # 80005bd8 <printf>
  printf("\n");
    80005bbc:	00002517          	auipc	a0,0x2
    80005bc0:	48c50513          	addi	a0,a0,1164 # 80008048 <etext+0x48>
    80005bc4:	00000097          	auipc	ra,0x0
    80005bc8:	014080e7          	jalr	20(ra) # 80005bd8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bcc:	4785                	li	a5,1
    80005bce:	00003717          	auipc	a4,0x3
    80005bd2:	ccf72f23          	sw	a5,-802(a4) # 800088ac <panicked>
  for(;;)
    80005bd6:	a001                	j	80005bd6 <panic+0x48>

0000000080005bd8 <printf>:
{
    80005bd8:	7131                	addi	sp,sp,-192
    80005bda:	fc86                	sd	ra,120(sp)
    80005bdc:	f8a2                	sd	s0,112(sp)
    80005bde:	f4a6                	sd	s1,104(sp)
    80005be0:	f0ca                	sd	s2,96(sp)
    80005be2:	ecce                	sd	s3,88(sp)
    80005be4:	e8d2                	sd	s4,80(sp)
    80005be6:	e4d6                	sd	s5,72(sp)
    80005be8:	e0da                	sd	s6,64(sp)
    80005bea:	fc5e                	sd	s7,56(sp)
    80005bec:	f862                	sd	s8,48(sp)
    80005bee:	f466                	sd	s9,40(sp)
    80005bf0:	f06a                	sd	s10,32(sp)
    80005bf2:	ec6e                	sd	s11,24(sp)
    80005bf4:	0100                	addi	s0,sp,128
    80005bf6:	8a2a                	mv	s4,a0
    80005bf8:	e40c                	sd	a1,8(s0)
    80005bfa:	e810                	sd	a2,16(s0)
    80005bfc:	ec14                	sd	a3,24(s0)
    80005bfe:	f018                	sd	a4,32(s0)
    80005c00:	f41c                	sd	a5,40(s0)
    80005c02:	03043823          	sd	a6,48(s0)
    80005c06:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c0a:	0001cd97          	auipc	s11,0x1c
    80005c0e:	0e6dad83          	lw	s11,230(s11) # 80021cf0 <pr+0x18>
  if(locking)
    80005c12:	020d9b63          	bnez	s11,80005c48 <printf+0x70>
  if (fmt == 0)
    80005c16:	040a0263          	beqz	s4,80005c5a <printf+0x82>
  va_start(ap, fmt);
    80005c1a:	00840793          	addi	a5,s0,8
    80005c1e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c22:	000a4503          	lbu	a0,0(s4)
    80005c26:	14050f63          	beqz	a0,80005d84 <printf+0x1ac>
    80005c2a:	4981                	li	s3,0
    if(c != '%'){
    80005c2c:	02500a93          	li	s5,37
    switch(c){
    80005c30:	07000b93          	li	s7,112
  consputc('x');
    80005c34:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c36:	00003b17          	auipc	s6,0x3
    80005c3a:	bbab0b13          	addi	s6,s6,-1094 # 800087f0 <digits>
    switch(c){
    80005c3e:	07300c93          	li	s9,115
    80005c42:	06400c13          	li	s8,100
    80005c46:	a82d                	j	80005c80 <printf+0xa8>
    acquire(&pr.lock);
    80005c48:	0001c517          	auipc	a0,0x1c
    80005c4c:	09050513          	addi	a0,a0,144 # 80021cd8 <pr>
    80005c50:	00000097          	auipc	ra,0x0
    80005c54:	47a080e7          	jalr	1146(ra) # 800060ca <acquire>
    80005c58:	bf7d                	j	80005c16 <printf+0x3e>
    panic("null fmt");
    80005c5a:	00003517          	auipc	a0,0x3
    80005c5e:	b7e50513          	addi	a0,a0,-1154 # 800087d8 <syscalls+0x408>
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	f2c080e7          	jalr	-212(ra) # 80005b8e <panic>
      consputc(c);
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	c62080e7          	jalr	-926(ra) # 800058cc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c72:	2985                	addiw	s3,s3,1
    80005c74:	013a07b3          	add	a5,s4,s3
    80005c78:	0007c503          	lbu	a0,0(a5)
    80005c7c:	10050463          	beqz	a0,80005d84 <printf+0x1ac>
    if(c != '%'){
    80005c80:	ff5515e3          	bne	a0,s5,80005c6a <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c84:	2985                	addiw	s3,s3,1
    80005c86:	013a07b3          	add	a5,s4,s3
    80005c8a:	0007c783          	lbu	a5,0(a5)
    80005c8e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005c92:	cbed                	beqz	a5,80005d84 <printf+0x1ac>
    switch(c){
    80005c94:	05778a63          	beq	a5,s7,80005ce8 <printf+0x110>
    80005c98:	02fbf663          	bgeu	s7,a5,80005cc4 <printf+0xec>
    80005c9c:	09978863          	beq	a5,s9,80005d2c <printf+0x154>
    80005ca0:	07800713          	li	a4,120
    80005ca4:	0ce79563          	bne	a5,a4,80005d6e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005ca8:	f8843783          	ld	a5,-120(s0)
    80005cac:	00878713          	addi	a4,a5,8
    80005cb0:	f8e43423          	sd	a4,-120(s0)
    80005cb4:	4605                	li	a2,1
    80005cb6:	85ea                	mv	a1,s10
    80005cb8:	4388                	lw	a0,0(a5)
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	e32080e7          	jalr	-462(ra) # 80005aec <printint>
      break;
    80005cc2:	bf45                	j	80005c72 <printf+0x9a>
    switch(c){
    80005cc4:	09578f63          	beq	a5,s5,80005d62 <printf+0x18a>
    80005cc8:	0b879363          	bne	a5,s8,80005d6e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005ccc:	f8843783          	ld	a5,-120(s0)
    80005cd0:	00878713          	addi	a4,a5,8
    80005cd4:	f8e43423          	sd	a4,-120(s0)
    80005cd8:	4605                	li	a2,1
    80005cda:	45a9                	li	a1,10
    80005cdc:	4388                	lw	a0,0(a5)
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	e0e080e7          	jalr	-498(ra) # 80005aec <printint>
      break;
    80005ce6:	b771                	j	80005c72 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ce8:	f8843783          	ld	a5,-120(s0)
    80005cec:	00878713          	addi	a4,a5,8
    80005cf0:	f8e43423          	sd	a4,-120(s0)
    80005cf4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005cf8:	03000513          	li	a0,48
    80005cfc:	00000097          	auipc	ra,0x0
    80005d00:	bd0080e7          	jalr	-1072(ra) # 800058cc <consputc>
  consputc('x');
    80005d04:	07800513          	li	a0,120
    80005d08:	00000097          	auipc	ra,0x0
    80005d0c:	bc4080e7          	jalr	-1084(ra) # 800058cc <consputc>
    80005d10:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d12:	03c95793          	srli	a5,s2,0x3c
    80005d16:	97da                	add	a5,a5,s6
    80005d18:	0007c503          	lbu	a0,0(a5)
    80005d1c:	00000097          	auipc	ra,0x0
    80005d20:	bb0080e7          	jalr	-1104(ra) # 800058cc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d24:	0912                	slli	s2,s2,0x4
    80005d26:	34fd                	addiw	s1,s1,-1
    80005d28:	f4ed                	bnez	s1,80005d12 <printf+0x13a>
    80005d2a:	b7a1                	j	80005c72 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d2c:	f8843783          	ld	a5,-120(s0)
    80005d30:	00878713          	addi	a4,a5,8
    80005d34:	f8e43423          	sd	a4,-120(s0)
    80005d38:	6384                	ld	s1,0(a5)
    80005d3a:	cc89                	beqz	s1,80005d54 <printf+0x17c>
      for(; *s; s++)
    80005d3c:	0004c503          	lbu	a0,0(s1)
    80005d40:	d90d                	beqz	a0,80005c72 <printf+0x9a>
        consputc(*s);
    80005d42:	00000097          	auipc	ra,0x0
    80005d46:	b8a080e7          	jalr	-1142(ra) # 800058cc <consputc>
      for(; *s; s++)
    80005d4a:	0485                	addi	s1,s1,1
    80005d4c:	0004c503          	lbu	a0,0(s1)
    80005d50:	f96d                	bnez	a0,80005d42 <printf+0x16a>
    80005d52:	b705                	j	80005c72 <printf+0x9a>
        s = "(null)";
    80005d54:	00003497          	auipc	s1,0x3
    80005d58:	a7c48493          	addi	s1,s1,-1412 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005d5c:	02800513          	li	a0,40
    80005d60:	b7cd                	j	80005d42 <printf+0x16a>
      consputc('%');
    80005d62:	8556                	mv	a0,s5
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	b68080e7          	jalr	-1176(ra) # 800058cc <consputc>
      break;
    80005d6c:	b719                	j	80005c72 <printf+0x9a>
      consputc('%');
    80005d6e:	8556                	mv	a0,s5
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	b5c080e7          	jalr	-1188(ra) # 800058cc <consputc>
      consputc(c);
    80005d78:	8526                	mv	a0,s1
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	b52080e7          	jalr	-1198(ra) # 800058cc <consputc>
      break;
    80005d82:	bdc5                	j	80005c72 <printf+0x9a>
  if(locking)
    80005d84:	020d9163          	bnez	s11,80005da6 <printf+0x1ce>
}
    80005d88:	70e6                	ld	ra,120(sp)
    80005d8a:	7446                	ld	s0,112(sp)
    80005d8c:	74a6                	ld	s1,104(sp)
    80005d8e:	7906                	ld	s2,96(sp)
    80005d90:	69e6                	ld	s3,88(sp)
    80005d92:	6a46                	ld	s4,80(sp)
    80005d94:	6aa6                	ld	s5,72(sp)
    80005d96:	6b06                	ld	s6,64(sp)
    80005d98:	7be2                	ld	s7,56(sp)
    80005d9a:	7c42                	ld	s8,48(sp)
    80005d9c:	7ca2                	ld	s9,40(sp)
    80005d9e:	7d02                	ld	s10,32(sp)
    80005da0:	6de2                	ld	s11,24(sp)
    80005da2:	6129                	addi	sp,sp,192
    80005da4:	8082                	ret
    release(&pr.lock);
    80005da6:	0001c517          	auipc	a0,0x1c
    80005daa:	f3250513          	addi	a0,a0,-206 # 80021cd8 <pr>
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	3d0080e7          	jalr	976(ra) # 8000617e <release>
}
    80005db6:	bfc9                	j	80005d88 <printf+0x1b0>

0000000080005db8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005db8:	1101                	addi	sp,sp,-32
    80005dba:	ec06                	sd	ra,24(sp)
    80005dbc:	e822                	sd	s0,16(sp)
    80005dbe:	e426                	sd	s1,8(sp)
    80005dc0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005dc2:	0001c497          	auipc	s1,0x1c
    80005dc6:	f1648493          	addi	s1,s1,-234 # 80021cd8 <pr>
    80005dca:	00003597          	auipc	a1,0x3
    80005dce:	a1e58593          	addi	a1,a1,-1506 # 800087e8 <syscalls+0x418>
    80005dd2:	8526                	mv	a0,s1
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	266080e7          	jalr	614(ra) # 8000603a <initlock>
  pr.locking = 1;
    80005ddc:	4785                	li	a5,1
    80005dde:	cc9c                	sw	a5,24(s1)
}
    80005de0:	60e2                	ld	ra,24(sp)
    80005de2:	6442                	ld	s0,16(sp)
    80005de4:	64a2                	ld	s1,8(sp)
    80005de6:	6105                	addi	sp,sp,32
    80005de8:	8082                	ret

0000000080005dea <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005dea:	1141                	addi	sp,sp,-16
    80005dec:	e406                	sd	ra,8(sp)
    80005dee:	e022                	sd	s0,0(sp)
    80005df0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005df2:	100007b7          	lui	a5,0x10000
    80005df6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005dfa:	f8000713          	li	a4,-128
    80005dfe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e02:	470d                	li	a4,3
    80005e04:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e08:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e0c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e10:	469d                	li	a3,7
    80005e12:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e16:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e1a:	00003597          	auipc	a1,0x3
    80005e1e:	9ee58593          	addi	a1,a1,-1554 # 80008808 <digits+0x18>
    80005e22:	0001c517          	auipc	a0,0x1c
    80005e26:	ed650513          	addi	a0,a0,-298 # 80021cf8 <uart_tx_lock>
    80005e2a:	00000097          	auipc	ra,0x0
    80005e2e:	210080e7          	jalr	528(ra) # 8000603a <initlock>
}
    80005e32:	60a2                	ld	ra,8(sp)
    80005e34:	6402                	ld	s0,0(sp)
    80005e36:	0141                	addi	sp,sp,16
    80005e38:	8082                	ret

0000000080005e3a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e3a:	1101                	addi	sp,sp,-32
    80005e3c:	ec06                	sd	ra,24(sp)
    80005e3e:	e822                	sd	s0,16(sp)
    80005e40:	e426                	sd	s1,8(sp)
    80005e42:	1000                	addi	s0,sp,32
    80005e44:	84aa                	mv	s1,a0
  push_off();
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	238080e7          	jalr	568(ra) # 8000607e <push_off>

  if(panicked){
    80005e4e:	00003797          	auipc	a5,0x3
    80005e52:	a5e7a783          	lw	a5,-1442(a5) # 800088ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e56:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e5a:	c391                	beqz	a5,80005e5e <uartputc_sync+0x24>
    for(;;)
    80005e5c:	a001                	j	80005e5c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e5e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e62:	0207f793          	andi	a5,a5,32
    80005e66:	dfe5                	beqz	a5,80005e5e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e68:	0ff4f513          	andi	a0,s1,255
    80005e6c:	100007b7          	lui	a5,0x10000
    80005e70:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	2aa080e7          	jalr	682(ra) # 8000611e <pop_off>
}
    80005e7c:	60e2                	ld	ra,24(sp)
    80005e7e:	6442                	ld	s0,16(sp)
    80005e80:	64a2                	ld	s1,8(sp)
    80005e82:	6105                	addi	sp,sp,32
    80005e84:	8082                	ret

0000000080005e86 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e86:	00003797          	auipc	a5,0x3
    80005e8a:	a2a7b783          	ld	a5,-1494(a5) # 800088b0 <uart_tx_r>
    80005e8e:	00003717          	auipc	a4,0x3
    80005e92:	a2a73703          	ld	a4,-1494(a4) # 800088b8 <uart_tx_w>
    80005e96:	06f70a63          	beq	a4,a5,80005f0a <uartstart+0x84>
{
    80005e9a:	7139                	addi	sp,sp,-64
    80005e9c:	fc06                	sd	ra,56(sp)
    80005e9e:	f822                	sd	s0,48(sp)
    80005ea0:	f426                	sd	s1,40(sp)
    80005ea2:	f04a                	sd	s2,32(sp)
    80005ea4:	ec4e                	sd	s3,24(sp)
    80005ea6:	e852                	sd	s4,16(sp)
    80005ea8:	e456                	sd	s5,8(sp)
    80005eaa:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005eac:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005eb0:	0001ca17          	auipc	s4,0x1c
    80005eb4:	e48a0a13          	addi	s4,s4,-440 # 80021cf8 <uart_tx_lock>
    uart_tx_r += 1;
    80005eb8:	00003497          	auipc	s1,0x3
    80005ebc:	9f848493          	addi	s1,s1,-1544 # 800088b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ec0:	00003997          	auipc	s3,0x3
    80005ec4:	9f898993          	addi	s3,s3,-1544 # 800088b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ec8:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ecc:	02077713          	andi	a4,a4,32
    80005ed0:	c705                	beqz	a4,80005ef8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ed2:	01f7f713          	andi	a4,a5,31
    80005ed6:	9752                	add	a4,a4,s4
    80005ed8:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005edc:	0785                	addi	a5,a5,1
    80005ede:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ee0:	8526                	mv	a0,s1
    80005ee2:	ffffb097          	auipc	ra,0xffffb
    80005ee6:	67c080e7          	jalr	1660(ra) # 8000155e <wakeup>
    
    WriteReg(THR, c);
    80005eea:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005eee:	609c                	ld	a5,0(s1)
    80005ef0:	0009b703          	ld	a4,0(s3)
    80005ef4:	fcf71ae3          	bne	a4,a5,80005ec8 <uartstart+0x42>
  }
}
    80005ef8:	70e2                	ld	ra,56(sp)
    80005efa:	7442                	ld	s0,48(sp)
    80005efc:	74a2                	ld	s1,40(sp)
    80005efe:	7902                	ld	s2,32(sp)
    80005f00:	69e2                	ld	s3,24(sp)
    80005f02:	6a42                	ld	s4,16(sp)
    80005f04:	6aa2                	ld	s5,8(sp)
    80005f06:	6121                	addi	sp,sp,64
    80005f08:	8082                	ret
    80005f0a:	8082                	ret

0000000080005f0c <uartputc>:
{
    80005f0c:	7179                	addi	sp,sp,-48
    80005f0e:	f406                	sd	ra,40(sp)
    80005f10:	f022                	sd	s0,32(sp)
    80005f12:	ec26                	sd	s1,24(sp)
    80005f14:	e84a                	sd	s2,16(sp)
    80005f16:	e44e                	sd	s3,8(sp)
    80005f18:	e052                	sd	s4,0(sp)
    80005f1a:	1800                	addi	s0,sp,48
    80005f1c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f1e:	0001c517          	auipc	a0,0x1c
    80005f22:	dda50513          	addi	a0,a0,-550 # 80021cf8 <uart_tx_lock>
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	1a4080e7          	jalr	420(ra) # 800060ca <acquire>
  if(panicked){
    80005f2e:	00003797          	auipc	a5,0x3
    80005f32:	97e7a783          	lw	a5,-1666(a5) # 800088ac <panicked>
    80005f36:	e7c9                	bnez	a5,80005fc0 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f38:	00003717          	auipc	a4,0x3
    80005f3c:	98073703          	ld	a4,-1664(a4) # 800088b8 <uart_tx_w>
    80005f40:	00003797          	auipc	a5,0x3
    80005f44:	9707b783          	ld	a5,-1680(a5) # 800088b0 <uart_tx_r>
    80005f48:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f4c:	0001c997          	auipc	s3,0x1c
    80005f50:	dac98993          	addi	s3,s3,-596 # 80021cf8 <uart_tx_lock>
    80005f54:	00003497          	auipc	s1,0x3
    80005f58:	95c48493          	addi	s1,s1,-1700 # 800088b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f5c:	00003917          	auipc	s2,0x3
    80005f60:	95c90913          	addi	s2,s2,-1700 # 800088b8 <uart_tx_w>
    80005f64:	00e79f63          	bne	a5,a4,80005f82 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005f68:	85ce                	mv	a1,s3
    80005f6a:	8526                	mv	a0,s1
    80005f6c:	ffffb097          	auipc	ra,0xffffb
    80005f70:	58e080e7          	jalr	1422(ra) # 800014fa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f74:	00093703          	ld	a4,0(s2)
    80005f78:	609c                	ld	a5,0(s1)
    80005f7a:	02078793          	addi	a5,a5,32
    80005f7e:	fee785e3          	beq	a5,a4,80005f68 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f82:	0001c497          	auipc	s1,0x1c
    80005f86:	d7648493          	addi	s1,s1,-650 # 80021cf8 <uart_tx_lock>
    80005f8a:	01f77793          	andi	a5,a4,31
    80005f8e:	97a6                	add	a5,a5,s1
    80005f90:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005f94:	0705                	addi	a4,a4,1
    80005f96:	00003797          	auipc	a5,0x3
    80005f9a:	92e7b123          	sd	a4,-1758(a5) # 800088b8 <uart_tx_w>
  uartstart();
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	ee8080e7          	jalr	-280(ra) # 80005e86 <uartstart>
  release(&uart_tx_lock);
    80005fa6:	8526                	mv	a0,s1
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	1d6080e7          	jalr	470(ra) # 8000617e <release>
}
    80005fb0:	70a2                	ld	ra,40(sp)
    80005fb2:	7402                	ld	s0,32(sp)
    80005fb4:	64e2                	ld	s1,24(sp)
    80005fb6:	6942                	ld	s2,16(sp)
    80005fb8:	69a2                	ld	s3,8(sp)
    80005fba:	6a02                	ld	s4,0(sp)
    80005fbc:	6145                	addi	sp,sp,48
    80005fbe:	8082                	ret
    for(;;)
    80005fc0:	a001                	j	80005fc0 <uartputc+0xb4>

0000000080005fc2 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fc2:	1141                	addi	sp,sp,-16
    80005fc4:	e422                	sd	s0,8(sp)
    80005fc6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fc8:	100007b7          	lui	a5,0x10000
    80005fcc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005fd0:	8b85                	andi	a5,a5,1
    80005fd2:	cb91                	beqz	a5,80005fe6 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005fd4:	100007b7          	lui	a5,0x10000
    80005fd8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005fdc:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005fe0:	6422                	ld	s0,8(sp)
    80005fe2:	0141                	addi	sp,sp,16
    80005fe4:	8082                	ret
    return -1;
    80005fe6:	557d                	li	a0,-1
    80005fe8:	bfe5                	j	80005fe0 <uartgetc+0x1e>

0000000080005fea <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005fea:	1101                	addi	sp,sp,-32
    80005fec:	ec06                	sd	ra,24(sp)
    80005fee:	e822                	sd	s0,16(sp)
    80005ff0:	e426                	sd	s1,8(sp)
    80005ff2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005ff4:	54fd                	li	s1,-1
    80005ff6:	a029                	j	80006000 <uartintr+0x16>
      break;
    consoleintr(c);
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	916080e7          	jalr	-1770(ra) # 8000590e <consoleintr>
    int c = uartgetc();
    80006000:	00000097          	auipc	ra,0x0
    80006004:	fc2080e7          	jalr	-62(ra) # 80005fc2 <uartgetc>
    if(c == -1)
    80006008:	fe9518e3          	bne	a0,s1,80005ff8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000600c:	0001c497          	auipc	s1,0x1c
    80006010:	cec48493          	addi	s1,s1,-788 # 80021cf8 <uart_tx_lock>
    80006014:	8526                	mv	a0,s1
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	0b4080e7          	jalr	180(ra) # 800060ca <acquire>
  uartstart();
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	e68080e7          	jalr	-408(ra) # 80005e86 <uartstart>
  release(&uart_tx_lock);
    80006026:	8526                	mv	a0,s1
    80006028:	00000097          	auipc	ra,0x0
    8000602c:	156080e7          	jalr	342(ra) # 8000617e <release>
}
    80006030:	60e2                	ld	ra,24(sp)
    80006032:	6442                	ld	s0,16(sp)
    80006034:	64a2                	ld	s1,8(sp)
    80006036:	6105                	addi	sp,sp,32
    80006038:	8082                	ret

000000008000603a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000603a:	1141                	addi	sp,sp,-16
    8000603c:	e422                	sd	s0,8(sp)
    8000603e:	0800                	addi	s0,sp,16
  lk->name = name;
    80006040:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006042:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006046:	00053823          	sd	zero,16(a0)
}
    8000604a:	6422                	ld	s0,8(sp)
    8000604c:	0141                	addi	sp,sp,16
    8000604e:	8082                	ret

0000000080006050 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006050:	411c                	lw	a5,0(a0)
    80006052:	e399                	bnez	a5,80006058 <holding+0x8>
    80006054:	4501                	li	a0,0
  return r;
}
    80006056:	8082                	ret
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006062:	6904                	ld	s1,16(a0)
    80006064:	ffffb097          	auipc	ra,0xffffb
    80006068:	dd2080e7          	jalr	-558(ra) # 80000e36 <mycpu>
    8000606c:	40a48533          	sub	a0,s1,a0
    80006070:	00153513          	seqz	a0,a0
}
    80006074:	60e2                	ld	ra,24(sp)
    80006076:	6442                	ld	s0,16(sp)
    80006078:	64a2                	ld	s1,8(sp)
    8000607a:	6105                	addi	sp,sp,32
    8000607c:	8082                	ret

000000008000607e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000607e:	1101                	addi	sp,sp,-32
    80006080:	ec06                	sd	ra,24(sp)
    80006082:	e822                	sd	s0,16(sp)
    80006084:	e426                	sd	s1,8(sp)
    80006086:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006088:	100024f3          	csrr	s1,sstatus
    8000608c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006090:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006092:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006096:	ffffb097          	auipc	ra,0xffffb
    8000609a:	da0080e7          	jalr	-608(ra) # 80000e36 <mycpu>
    8000609e:	5d3c                	lw	a5,120(a0)
    800060a0:	cf89                	beqz	a5,800060ba <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800060a2:	ffffb097          	auipc	ra,0xffffb
    800060a6:	d94080e7          	jalr	-620(ra) # 80000e36 <mycpu>
    800060aa:	5d3c                	lw	a5,120(a0)
    800060ac:	2785                	addiw	a5,a5,1
    800060ae:	dd3c                	sw	a5,120(a0)
}
    800060b0:	60e2                	ld	ra,24(sp)
    800060b2:	6442                	ld	s0,16(sp)
    800060b4:	64a2                	ld	s1,8(sp)
    800060b6:	6105                	addi	sp,sp,32
    800060b8:	8082                	ret
    mycpu()->intena = old;
    800060ba:	ffffb097          	auipc	ra,0xffffb
    800060be:	d7c080e7          	jalr	-644(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060c2:	8085                	srli	s1,s1,0x1
    800060c4:	8885                	andi	s1,s1,1
    800060c6:	dd64                	sw	s1,124(a0)
    800060c8:	bfe9                	j	800060a2 <push_off+0x24>

00000000800060ca <acquire>:
{
    800060ca:	1101                	addi	sp,sp,-32
    800060cc:	ec06                	sd	ra,24(sp)
    800060ce:	e822                	sd	s0,16(sp)
    800060d0:	e426                	sd	s1,8(sp)
    800060d2:	1000                	addi	s0,sp,32
    800060d4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	fa8080e7          	jalr	-88(ra) # 8000607e <push_off>
  if(holding(lk))
    800060de:	8526                	mv	a0,s1
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	f70080e7          	jalr	-144(ra) # 80006050 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060e8:	4705                	li	a4,1
  if(holding(lk))
    800060ea:	e115                	bnez	a0,8000610e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060ec:	87ba                	mv	a5,a4
    800060ee:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060f2:	2781                	sext.w	a5,a5
    800060f4:	ffe5                	bnez	a5,800060ec <acquire+0x22>
  __sync_synchronize();
    800060f6:	0ff0000f          	fence
  lk->cpu = mycpu();
    800060fa:	ffffb097          	auipc	ra,0xffffb
    800060fe:	d3c080e7          	jalr	-708(ra) # 80000e36 <mycpu>
    80006102:	e888                	sd	a0,16(s1)
}
    80006104:	60e2                	ld	ra,24(sp)
    80006106:	6442                	ld	s0,16(sp)
    80006108:	64a2                	ld	s1,8(sp)
    8000610a:	6105                	addi	sp,sp,32
    8000610c:	8082                	ret
    panic("acquire");
    8000610e:	00002517          	auipc	a0,0x2
    80006112:	70250513          	addi	a0,a0,1794 # 80008810 <digits+0x20>
    80006116:	00000097          	auipc	ra,0x0
    8000611a:	a78080e7          	jalr	-1416(ra) # 80005b8e <panic>

000000008000611e <pop_off>:

void
pop_off(void)
{
    8000611e:	1141                	addi	sp,sp,-16
    80006120:	e406                	sd	ra,8(sp)
    80006122:	e022                	sd	s0,0(sp)
    80006124:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006126:	ffffb097          	auipc	ra,0xffffb
    8000612a:	d10080e7          	jalr	-752(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000612e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006132:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006134:	e78d                	bnez	a5,8000615e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006136:	5d3c                	lw	a5,120(a0)
    80006138:	02f05b63          	blez	a5,8000616e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000613c:	37fd                	addiw	a5,a5,-1
    8000613e:	0007871b          	sext.w	a4,a5
    80006142:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006144:	eb09                	bnez	a4,80006156 <pop_off+0x38>
    80006146:	5d7c                	lw	a5,124(a0)
    80006148:	c799                	beqz	a5,80006156 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000614a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000614e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006152:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006156:	60a2                	ld	ra,8(sp)
    80006158:	6402                	ld	s0,0(sp)
    8000615a:	0141                	addi	sp,sp,16
    8000615c:	8082                	ret
    panic("pop_off - interruptible");
    8000615e:	00002517          	auipc	a0,0x2
    80006162:	6ba50513          	addi	a0,a0,1722 # 80008818 <digits+0x28>
    80006166:	00000097          	auipc	ra,0x0
    8000616a:	a28080e7          	jalr	-1496(ra) # 80005b8e <panic>
    panic("pop_off");
    8000616e:	00002517          	auipc	a0,0x2
    80006172:	6c250513          	addi	a0,a0,1730 # 80008830 <digits+0x40>
    80006176:	00000097          	auipc	ra,0x0
    8000617a:	a18080e7          	jalr	-1512(ra) # 80005b8e <panic>

000000008000617e <release>:
{
    8000617e:	1101                	addi	sp,sp,-32
    80006180:	ec06                	sd	ra,24(sp)
    80006182:	e822                	sd	s0,16(sp)
    80006184:	e426                	sd	s1,8(sp)
    80006186:	1000                	addi	s0,sp,32
    80006188:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	ec6080e7          	jalr	-314(ra) # 80006050 <holding>
    80006192:	c115                	beqz	a0,800061b6 <release+0x38>
  lk->cpu = 0;
    80006194:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006198:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000619c:	0f50000f          	fence	iorw,ow
    800061a0:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	f7a080e7          	jalr	-134(ra) # 8000611e <pop_off>
}
    800061ac:	60e2                	ld	ra,24(sp)
    800061ae:	6442                	ld	s0,16(sp)
    800061b0:	64a2                	ld	s1,8(sp)
    800061b2:	6105                	addi	sp,sp,32
    800061b4:	8082                	ret
    panic("release");
    800061b6:	00002517          	auipc	a0,0x2
    800061ba:	68250513          	addi	a0,a0,1666 # 80008838 <digits+0x48>
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	9d0080e7          	jalr	-1584(ra) # 80005b8e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
