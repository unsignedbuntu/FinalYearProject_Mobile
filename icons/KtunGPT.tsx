import React from "react"

interface KtunGPTProps extends React.SVGProps<SVGSVGElement> {
  width: number;
  height: number;
  className?: string;
}

export default function KtunGPT({ width = 50, height = 50, className }: KtunGPTProps) {
  return (
        <svg width={width} height={height} viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M42.5305 16.9717L41.97 18.3186C41.56 19.3046 40.2582 19.3046 39.848 18.3186L39.2877 16.9717C38.2889 14.5702 36.4898 12.6581 34.2448 11.6121L32.5182 10.8077C31.5848 10.3727 31.5848 8.94955 32.5182 8.51457L34.1482 7.7551C36.4509 6.68217 38.2823 4.69936 39.2639 2.21626L39.8393 0.760787C40.2405 -0.253596 41.5777 -0.253596 41.9786 0.760787L42.5541 2.21626C43.5359 4.69936 45.3673 6.68217 47.67 7.7551L49.2998 8.51457C50.2334 8.94955 50.2334 10.3727 49.2998 10.8077L47.5734 11.6121C45.3284 12.6581 43.5293 14.5702 42.5305 16.9717ZM40.9091 23.8095C42.4307 23.8095 43.8941 23.5483 45.2607 23.0667C45.3886 24.089 45.4545 25.1317 45.4545 26.1905C45.4545 39.34 35.2791 50 22.7273 50C18.858 50 15.2145 48.9871 12.0254 47.2005L0 50L2.6723 37.4019C0.966909 34.061 0 30.244 0 26.1905C0 13.0408 10.1753 2.38095 22.7273 2.38095C24.7855 2.38095 26.7798 2.6676 28.6759 3.20483C27.7775 5.10993 27.2727 7.25512 27.2727 9.52381C27.2727 17.4136 33.378 23.8095 40.9091 23.8095ZM11.3636 26.1905C11.3636 32.7652 16.4513 38.0952 22.7273 38.0952C29.0032 38.0952 34.0909 32.7652 34.0909 26.1905H29.5455C29.5455 30.1355 26.493 33.3333 22.7273 33.3333C18.9616 33.3333 15.9091 30.1355 15.9091 26.1905H11.3636Z" fill="#4000FF"/>
    </svg>
  )
}
