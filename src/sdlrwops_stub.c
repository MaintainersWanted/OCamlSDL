#include <string.h>
#include <SDL.h>

#include "common.h"
#include "sdlrwops_stub.h"

#define RWOPS_DATA(r) ((r)->hidden.unknown.data1)
#define CHECK_RWOPS(r) do{             \
  if(! RWOPS_DATA(r)) {                \
    SDL_SetError("closed Sdl.rwops") ; \
    return -1; }                       \
} while(0)

struct mem_pos_data {
  void *base;
  size_t off;
  size_t max;
};

#define RWmem_pos_data(r) ((struct mem_pos_data *)(r->hidden.unknown.data1))

static int mlsdl_mem_seek(SDL_RWops *context, int offset, int whence)
{
  size_t newoff;
  struct mem_pos_data *pdata = RWmem_pos_data(context);

  CHECK_RWOPS(context);
  
  switch (whence) {
  case SEEK_SET:
    newoff = offset;
    break;
  case SEEK_CUR:
    newoff = pdata->off+offset;
    break;
  case SEEK_END:
    newoff = pdata->max+offset;
    break;
  default:
    SDL_SetError("Unknown value for 'whence'");
    return -1;
  }
  if ( newoff < 0 || newoff > pdata->max )
    return -1;
  pdata->off = newoff;
  return newoff;
}

static int mlsdl_mem_read(SDL_RWops *context, void *ptr, int size, int maxnum)
{
  int num;
  struct mem_pos_data *pdata = RWmem_pos_data(context);
  
  CHECK_RWOPS(context);
  num = maxnum;
  if (pdata->off + (num*size) > pdata->max)
    num = (pdata->max - pdata->off)/size;
  
  memcpy(ptr, pdata->base+pdata->off, num*size);
  pdata->off += num*size;
  return num;
}

static int mlsdl_mem_write(SDL_RWops *context, const void *ptr, int size, int num)
{
  return -1;
}

static int mlsdl_mem_close(SDL_RWops *context)
{
  struct mem_pos_data *pdata = RWmem_pos_data(context);
  void *base;
  if(! pdata) return 0;
  base = &pdata->base;
  remove_global_root(base);
  stat_free(pdata);
  RWmem_pos_data(context) = NULL;
  return 0;
}

CAMLprim value mlsdl_rwops_finalise(value rw)
{
  SDL_RWops *rwops = SDLRWops_val(rw);
  if(RWOPS_DATA(rwops))
    rwops->close(rwops);
  stat_free(rwops);
  return Val_unit;
}

CAMLprim value mlsdl_rw_from_mem(value buff)
{
  SDL_RWops *rwops;
  struct mem_pos_data *pdata;
  void *base;
  rwops = stat_alloc(sizeof *rwops);
  pdata = stat_alloc(sizeof *pdata);
  rwops->seek = mlsdl_mem_seek;
  rwops->read = mlsdl_mem_read;
  rwops->write = mlsdl_mem_write;
  rwops->close = mlsdl_mem_close;
  rwops->type  = MLSDL_RWOPS_MEM;
  RWmem_pos_data(rwops) = pdata;
  pdata->base = String_val(buff);
  base = &pdata->base;
  register_global_root(base);
  pdata->off = 0;
  pdata->max = string_length(buff);
  return abstract_ptr(rwops);
}

CAMLprim value mlsdl_rwops_close(value rw)
{
  SDL_RWops *rwops = SDLRWops_val(rw);
  if(RWOPS_DATA(rwops))
    rwops->close(rwops);
  return Val_unit;
}
