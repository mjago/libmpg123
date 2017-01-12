# coding: utf-8

require "./libmpg123/*"

@[Link("mpg123")]
lib LibMP
alias MPG_Export = Void
alias CInt = LibC::Int
alias CLong = LibC::Long
alias CFloat = LibC::Float
alias CDouble = LibC::Double
alias CChar = LibC::Char
alias MP_Handle = LibC::Int
alias Size = CLong

fun plain_error_str = mpg123_plain_strerror(code : CInt) : CChar*
                                                           fun error_str = mpg123_strerror(hndl : MP_Handle) : CChar*
                                                                                                               fun init = mpg123_init() : CInt
fun exit = mpg123_exit() : CInt
fun decoders = mpg123_decoders() : CChar**
                                   fun supported_decoders = mpg123_supported_decoders() : CChar**
                                                                                          fun current_decoder = mpg123_current_decoder(handle : MP_Handle*) : CChar*
                                                                                                                                                              fun new = mpg123_new(decoder : CChar*, err : CInt*) : MP_Handle*
                                                                                                                                                                                                                    fun open = mpg123_open(MP_Handle*, path : CChar*) : CInt
fun read = mpg123_read(MP_Handle*, outmemory : CChar*, outmemsize : Size, done : Size*) : CInt
fun encsize =  mpg123_encsize(encoding : CInt) : CInt

fun delete = mpg123_delete(mh : MP_Handle*) : Void
fun param = mpg123_param(mh : MP_Handle*, type : MP_Parms, value : CLong, fvalue : CDouble) : Void
fun buf_size = mpg123_outblock(MP_Handle*) : Size
fun get_format = mpg123_getformat(MP_Handle*, rate : CLong*, channels : CInt*, encoding : CInt*) : CInt

enum MP_Parms
MP_VERBOSE = 0
MP_FLAGS
MP_ADD_FLAGS MP_FORCE_RATE
MP_DOWN_SAMPLE MP_RVA
MP_DOWNSPEED MP_UPSPEED
MP_START_FRAME MP_DECODE_FRAMES
MP_ICY_INTERVAL MP_OUTSCALE
MP_TIMEOUT MP_REMOVE_FLAGS
MP_RESYNC_LIMIT MP_INDEX_SIZE
MP_PREFRAMES MP_FEEDPOOL
MP_FEEDBUFFER
end

enum MP_ParamFlags
MP_FORCE_MONO = 0x7
MP_MONO_LEFT = 0x1
MP_MONO_RIGHT = 0x2
MP_MONO_MIX = 0x4
MP_FORCE_STEREO = 0x8
MP_FORCE_8BIT = 0x10
MP_QUIET = 0x20
MP_GAPLESS = 0x40
MP_NO_RESYNC = 0x80
MP_SEEKBUFFER = 0x100
MP_FUZZY = 0x200
MP_FORCE_FLOAT = 0x400
MP_PLAIN_ID3TEXT = 0x800
MP_IGNORE_STREAMLENGTH = 0x1000
MP_SKIP_ID3V2 = 0x2000
MP_IGNORE_INFOFRAME = 0x4000
MP_AUTO_RESAMPLE = 0x8000
MP_PICTURE = 0x10000
MP_NO_PEEK_END = 0x20000
MP_FORCE_SEEKABLE = 0x40000
end

enum MP_Param_RVA
MP_RVA_OFF = 0
MP_RVA_MIX = 1
MP_RVA_ALBUM = 2
MP_RVA_MAX = MP_RVA_ALBUM
end

enum MP_Errors
MPG123_DONE = -12
MPG123_NEW_FORMAT = -11
MPG123_NEED_MORE = -10
MPG123_ERR = -1
MPG123_OK = 0
MPG123_BAD_OUTFORMAT
MPG123_BAD_CHANNEL
MPG123_BAD_RATE
MPG123_ERR_16TO8TABLE
MPG123_BAD_PARAM
MPG123_BAD_BUFFER
MPG123_OUT_OF_MEM
MPG123_NOT_INITIALIZED
MPG123_BAD_DECODER
MPG123_BAD_HANDLE
MPG123_NO_BUFFERS
MPG123_BAD_RVA
MPG123_NO_GAPLESS
MPG123_NO_SPACE
MPG123_BAD_TYPES
MPG123_BAD_BAND
MPG123_ERR_NULL
MPG123_ERR_READER
MPG123_NO_SEEK_FROM_END
MPG123_BAD_WHENCE
MPG123_NO_TIMEOUT
MPG123_BAD_FILE
MPG123_NO_SEEK
MPG123_NO_READER
MPG123_BAD_PARS
MPG123_BAD_INDEX_PAR
MPG123_OUT_OF_SYNC
MPG123_RESYNC_FAIL
MPG123_NO_8BIT
MPG123_BAD_ALIGN
MPG123_NULL_BUFFER
MPG123_NO_RELSEEK
MPG123_NULL_POINTER
MPG123_BAD_KEY
MPG123_NO_INDEX
MPG123_INDEX_FAIL
MPG123_BAD_DECODER_SETUP
MPG123_MISSING_FEATURE
MPG123_BAD_VALUE
MPG123_LSEEK_FAILED
MPG123_BAD_CUSTOM_IO
MPG123_LFS_OVERFLOW
MPG123_INT_OVERFLOW
end

enum MP_feature_set
MP_FEATURE_ABI_UTF8OPEN = 0
MP_FEATURE_OUTPUT_8BIT
MP_FEATURE_OUTPUT_16BIT
MP_FEATURE_OUTPUT_32BIT
MP_FEATURE_INDEX
MP_FEATURE_PARSE_ID3V2
MP_FEATURE_DECODE_LAYER1
MP_FEATURE_DECODE_LAYER2
MP_FEATURE_DECODE_LAYER3
MP_FEATURE_DECODE_ACCURATE
MP_FEATURE_DECODE_DOWNSAMPLE
MP_FEATURE_DECODE_NTOM
MP_FEATURE_PARSE_ICY
MP_FEATURE_TIMEOUT_READ
MP_FEATURE_EQUALIZER
end
end

module Libmpg123
  class Mp

    @handle : Pointer(LibMP::MP_Handle) | Nil
    #  @error  : Int32

    property handle
    #  property error

    def initialize
      @error = LibMP.init
    end

    def plain_error_str
      String.new(LibMP.plain_error_str(@error))
    end

    def decoders
      LibMP.decoders
    end

    def supported_decoders
      LibMP.supported_decoders
    end

    def decoder(val)
      (decoders + 1).value
    end

    def new(decoder)
      @handle = LibMP.new(nil, pointerof(@error))
    end

    def open(path)
      LibMP.open(@handle, path)
    end

    def read(bufp, buf_size, donep)
      LibMP.read(@handle, bufp, buf_size, donep)
    end

    def get_format(ratep, channelsp, encodingp)
      @error = LibMP.get_format(@handle, ratep, channelsp, encodingp)
    end

    def encsize(encoding)
      LibMP.encsize(encoding)
    end

    def buf_size
      LibMP.buf_size(@handle)
    end

    def exit
      LibMP.exit
    end
  end
end
